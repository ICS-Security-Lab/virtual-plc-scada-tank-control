A small, fully virtual industrial control setup: a simulated filling tank, a soft PLC running ladder logic, and a SCADA operator panel, all talking to each other over **Modbus TCP**. No hardware needed, just three free tools on one machine.

I work in cybersecurity and wanted to understand the ICS stack by building it instead of only reading about it. The full walkthrough is on Dev.to: **[Building a Virtual PLC + SCADA Tank Control System](https://dev.to/almahmudkhalif/building-a-virtual-plc-scada-tank-control-system-with-openplc-factory-io-and-soliscada-ele)**

---

## 📌 What This Project Does

An operator presses **Fill** or **Discharge** on a SCADA screen. The command travels over Modbus TCP to a PLC, the ladder logic opens the right valve, and the tank in the simulation fills or drains. Fill and discharge can never run at the same time.

| Layer | Role | Tool |
|---|---|---|
| Process (Level 0) | The thing being controlled | Factory I/O, Filling Tank scene |
| Controller (Level 1) | Runs the control logic | OpenPLC (Editor + Runtime) |
| Operator panel (Level 2) | Monitor and send commands | SoLiSCADA |

---

## 🧰 Tools Used

- **OpenPLC Editor and Runtime**: ladder logic and the soft PLC
- **Factory I/O**: the 3D simulated process (Filling Tank scene)
- **SoLiSCADA**: SCADA project, tags and runtime
- **VFDraw**: operator screen design
- **Modbus TCP**: the protocol connecting everything (port 502)

---

## 🧱 Step 1: Plan the Variables

Before drawing any rungs, I wrote down every signal I needed. Every address has to line up across all three tools, and a wrong address gives you silence instead of an error.

```iecst
VAR
  Fill_Btn    : BOOL AT %IX0.0;   (* fill push-button *)
  Disch_Btn   : BOOL AT %IX0.1;   (* discharge push-button *)
  Fill_Valve  : BOOL AT %QX0.0;
  Disch_Valve : BOOL AT %QX0.1;
  Fill_Light  : BOOL AT %QX0.2;
  Disch_Light : BOOL AT %QX0.3;
  Fill_Cmd    : BOOL AT %QX0.4;   (* command bit for SCADA *)
  Disch_Cmd   : BOOL AT %QX0.5;   (* command bit for SCADA *)

  Preset_s    : INT AT %MW1 := 10; (* operation time, seconds *)
  Level       : INT AT %MW0 := 0;  (* tank level, 0-100 % *)
  Timer_Disp  : INT AT %QW0;       (* remaining seconds *)
  Fill_Analog : INT AT %QW1;
  Disch_Analog: INT AT %QW2;

  T_Fill, T_Disch, Tick : TON;
  Fill_Seq, Disch_Seq   : BOOL;
END_VAR
```

![Variable declarations in OpenPLC Editor](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/9h8xesxrqkvtcebfg4e4.png)

---

## 🪜 Step 2: The Ladder Logic

The program is 30 rungs, but it breaks down into a few small ideas.

### Fill sequence (rungs 01 to 03)

```iecst
Fill_Seq := (Fill_Btn OR Fill_Seq OR Fill_Cmd)
            AND NOT Disch_Seq
            AND NOT T_Fill.Q;

T_Fill(IN := Fill_Seq, PT := Preset_T);
Fill_Valve := Fill_Seq;
```

- **Latch:** `Fill_Seq` holds itself on after the button is released.
- **Interlock:** `NOT Disch_Seq` blocks fill while a discharge is running. The discharge rung has the matching check on `Fill_Seq`.
- **Timer stop:** when `T_Fill` finishes, `Fill_Seq` drops and the valve closes.

![Fill sequence ladder rungs](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/xhpxvsedqnw4tunwiz6h.png)

### Discharge sequence (rungs 04 to 06)

Mirrors the fill sequence, with its own timer (`T_Disch`), its own valve, and the interlock pointing the other way.

![Discharge sequence ladder rungs](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/anbiqt6z9s9n02fq3sxe.png)

### Indicator lights and countdown (rungs 07 to 14)

The lights follow the two sequence flags. The elapsed time of the running timer is converted to seconds and subtracted from the preset:

```iecst
Left_Calc  := Preset_R - TIME_TO_S(T_Fill.ET);
Timer_Disp := TO_INT(Left_Calc);
```

![Indicator lights and countdown, part 1](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/xwyba9ydp012yjvc4yod.png)

![Indicator lights and countdown, part 2](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/3yai6ddac3a3750uvfwz.png)

![Indicator lights and countdown, part 3](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/o7vqoj6u7kfck8jr3uer.png)

### Configurable preset (rungs 15 to 18, 25, 26)

The operator sets the duration in seconds and the PLC converts it into a `TIME` value for the timer:

```iecst
Preset_s  := LIMIT(1, Preset_s, 30);   (* keep it between 1 and 30 s *)
Preset_ms := Preset_s * 1000;
Preset_T  := TO_TIME(Preset_ms);
Step_Lvl  := 100 / Preset_s;           (* level step used later *)
```

![Preset conversion rungs](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/nq9r55ikfulv51n5mr5d.png)

### Level simulation (rungs 19 to 24)

A 900 ms tick adds or subtracts a fixed step from `Level`, and a `LIMIT` block keeps it between 0 and 100. Rungs 23 and 24 also reset `Fill_Cmd` and `Disch_Cmd` once a sequence starts, so a SCADA button press behaves like a single pulse.

```iecst
(* every 900 ms *)
IF Fill_Seq THEN Level := Level + Step_Lvl; END_IF;
IF Disch_Seq THEN Level := Level - Step_Lvl; END_IF;
Level := LIMIT(0, Level, 100);
```

![Level simulation rungs, part 1](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/yt3oh3yjy0vm7yseo2ox.png)

![Level simulation rungs, part 2](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/q896yeo9iuueqrbvt51i.png)

### Valve outputs to Factory I/O (rungs 27 to 30)

Each valve writes `1000` to its analog output when open and `0` when closed. Factory I/O reads these values to move the valves in the scene.

![Valve output rungs, part 1](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/uci9hl9gdvcm46qrroi4.png)

![Valve output rungs, part 2](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/s7e4kzn1gt99z7f8efav.png)

---

## 🔌 Step 3: Connect OpenPLC to Factory I/O

I loaded the **Filling Tank (Timers)** scene in Factory I/O and started its Modbus TCP/IP server (the status bar shows "Modbus TCP/IP Server (Started)").

![Factory I/O Filling Tank scene with Modbus server started](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/yqc3b67bc1n9825rssfe.png)

OpenPLC then acts as the Modbus master. The runtime log confirms the connection:

```text
Device 'modbustank' loaded: 192.168.56.1:502
slave_id: 1
PLC State: RUNNING
```

![OpenPLC runtime log showing the Modbus device loaded](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/fxsryzxv4jvabn91ba7z.png)

---

## 🖥️ Step 4: Build the SCADA Project

In SoLiSCADA I created a project called `Tank_Filling_SCADA`.

![SoLiSCADA project creation](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/pv59jc7ju8m758mdz74s.png)

Inside the project explorer I added a graphics page (`Tank_Control`) and a trend object called `Tank Level Trend`.

![SCADA project explorer](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/2niw28ul00ze3dzcszr1.png)

Eight tags, all on the Modbus TCP driver:

| Tag | Type | Used for |
|---|---|---|
| `Fill_Cmd` | Switch | Fill command from the operator |
| `Disch_Cmd` | Switch | Discharge command from the operator |
| `Filling_Status` | Switch | Filling state |
| `Discharging_Status` | Switch | Discharging state |
| `Level` | Integer | Tank level |
| `Tank_Level_Raw` | Integer | Raw level value |
| `Preset_s` | Integer | Operation time in seconds |
| `Timer_Remaining` | Integer | Countdown value |

![SCADA tag list](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/qqzlwynf50d5c9o6zbsq.png)

---

## 🎛️ Step 5: Design the Operator Panel

The screen is drawn in VFDraw. It has a tank graphic with a level bar, Fill and Discharge buttons with ON/OFF text, fields for preset time, tank level (%) and time remaining, and an alarm bar at the bottom.

![Operator panel design in VFDraw](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/c99so9gpp8rba27o84cw.png)

In runtime, the question marks turn into live values:

![Operator panel running with live values](https://dev-to-uploads.s3.us-east-2.amazonaws.com/uploads/articles/ue8erumb624w60om8ulr.png)

---

## ✅ How to Verify

1. **Factory I/O:** the scene is running and the status bar says the Modbus TCP/IP server is started.
2. **OpenPLC runtime:** the log shows the Modbus device loaded and `PLC State: RUNNING`.
3. **SCADA runtime:** open the `Tank_Control` page. Tags should show live values, not question marks.
4. **Fill test:** press **Fill**. The text changes to ON, the level bar rises, and Time Remaining counts down from the preset.
5. **Finish test:** when the timer hits zero, the fill valve closes and the text returns to OFF.
6. **Interlock test:** press **Discharge** while a fill is running. The ladder logic ignores it until the fill ends.

---

## 💡 What I Learned

- **Write the variable list first.** Every address (`%IX`, `%QX`, `%MW`) has to match across three tools.
- **A latch plus an interlock is the simplest safe pattern** for stopping conflicting operations.
- **Command bits need to be cleared,** otherwise a SCADA button press stays on.
- **Check the scan time.** The runtime log showed scan overrun warnings. It still ran, but it needs investigating.
- **Modbus TCP has no authentication.** Anyone who can reach port 502 can write coils and registers, which matters a lot in real plants.

---

## ⚠️ Common Mistakes

| Mistake | What happens | Fix |
|---|---|---|
| Wrong Modbus address between tools | Values stay at zero or never change | Make a mapping table first and check every tag against it |
| Forgetting to start the Factory I/O Modbus server | OpenPLC cannot connect, you get timeouts | Start the server before running the PLC |
| Not clearing command bits | The SCADA button looks stuck on | Reset `Fill_Cmd` / `Disch_Cmd` in the ladder logic |
| Timer preset in the wrong type | Timer never fires or fires instantly | Convert seconds to a `TIME` value (rungs 25 and 26) |
| Leaving unused blocks in the ladder | Confusing logic and wasted scan time | Delete empty blocks |

---

## 🚧 Known Limitations and Next Steps

- The SCADA level is calculated inside the PLC. The Factory I/O level sensor input (`%IW0`) is declared but not wired into the logic yet, so the two can drift apart.
- The countdown shows `0:3` instead of a padded `00:03`.
- The Idle field on the screen is not a real status indicator yet.
- The level trend, high-level alarm, alarm timestamps and the acknowledge button still need to be configured and tested.
- Next up: use the real level sensor, finish the alarms and trend, then capture the Modbus traffic and test how easy it is to spoof a command.

---

## 🌐 Connect With Me
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/almahmudkhalif/)
[![Dev.to](https://img.shields.io/badge/Dev.to-Articles-black?logo=devdotto)](https://dev.to/almahmudkhalif/)
