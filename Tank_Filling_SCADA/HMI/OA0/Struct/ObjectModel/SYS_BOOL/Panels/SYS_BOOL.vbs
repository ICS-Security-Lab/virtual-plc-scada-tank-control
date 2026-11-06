Text1.Text = Form.TagName("@THIS@")
Text7.Text = Form.TagDescription("@THIS@")

Button6.Text = Form.GetTagOnDesc("@THIS@")
If Button6.Text = "" Then
	Button6.Text = "ON"
End If

Button7.Text = Form.GetTagOffDesc("@THIS@")
If Button7.Text = "" Then
	Button7.Text = "OFF"
End If

IF Form.IsDomainTag("@THIS@") = 1 THEN
	Button8.Visible = False
END IF

bOtherDomainTag = Form.OtherDomainTag(Form.TagName("@THIS@"))
IF bOtherDomainTag = True THEN
   Button8.Visible = False
END IF
onColor = Form.GetTagOnColor("@THIS@")
offColor = Form.GetTagOffColor("@THIS@")
defaultColor = 13160660

Button1.Visible = False
ImageOnFresh.Visible = False
ImageOFFFresh.Visible = False
TimerOnAlarm.Enable = False
TimerOFFAlarm.Enable = False

Dim timerCount

a = TAG("@THIS@")
'设置面板位号名称
TrdGraph3.SetPanelTagName Form.TagName("@THIS@")
Timer1_OnTimer()

'----------------------------------------------------------------
Sub Timer1_OnTimer()
	IF Form.GetTagType("@THIS@") <> 13 Then
		Form.ClosePopPic ""
	Else
		dwQua = Form.Quality("@THIS@")
	    IF CLng(dwQua)=0 Then
	    	Ellipse1.BackgroundColor = vbGreen
	    	IF Form.Alarm("@THIS@") <> False THEN
	    		Ellipse1.BackgroundColor = vbRed	
			END IF
			
			IF Form.Alarm("@THIS@") <> False THEN
	    		Text2.Text = ""
			Else 
				Text2.Text = "NR"
			END IF
			
			If Form.Tag("@THIS@") <> False Then
				Button6.BackgroundColor = onColor
				Button7.BackgroundColor = defaultColor
			Else
				Button6.BackgroundColor = defaultColor
				Button7.BackgroundColor = offColor
			End If
	    Else
	        Ellipse1.BackgroundColor = vbBlack
	        
	        IF timerCount >= 3 THEN
	        	Text2.Text = "RTDATA_BAD"
	        End If
			
			Button6.BackgroundColor = defaultColor
			Button7.BackgroundColor = defaultColor
	    End If  
	    IF Form.Alarm("@THIS@") <> False THEN
			Button1.Visible = True
		Else 
			Button1.Visible = False
		END IF
	    ShowAlarm()
	    IF ((TimerOnAlarm.Enable<>True) And (TimerOFFAlarm.Enable<>True)) THEN
	    	RefreshAlmSet()
	    END IF 
    End If
    
    timerCount = timerCount + 1
End Sub

Sub ShowAlarm()
dwQua = Form.Quality("@THIS@")
IF Form.Alarm("@THIS@") <> False And CLng(dwQua)=0 THEN
	If Form.Tag("@THIS@") <> False Then
		Text3.Text="ON"
	ELSE
		Text3.Text="OFF"
	End IF
ELSE
	Text3.Text=""	
END IF
End Sub
'----------------------------------------------------------------
'1为ON报警 2为OFF报警
Sub RefreshAlmSet()
		nAlmSwitch = Form.Tag("@THIS@.ALMSWITCH")
		if (nAlmSwitch And 1) THEN
			CheckBoxONAlarm.Value = 1
		ELSE
			CheckBoxONAlarm.Value = 0
		END IF
		if (nAlmSwitch And 2) THEN
			CheckBoxOFFAlarm.Value = 1
		ELSE
			CheckBoxOFFAlarm.Value = 0
		END IF
		
		Dim bAlarm
		bAlarm = Form.Tag("@THIS@.ALMENAB")
		CheckBoxONAlarm.Enabled = bAlarm
		CheckBoxOFFAlarm.Enabled = bAlarm
End Sub

'----------------------------------------------------------------
Sub CheckBoxONAlarm_OnLButtonDown(nFlag, x, y)
	TimerOnAlarm.Enable = True
	ImageOnFresh.Visible = True
	CheckBoxONAlarm.Enabled = False
	SetAlmSwitchByCheck()
End Sub

'----------------------------------------------------------------
Sub CheckBoxOFFAlarm_OnLButtonDown(nFlag, x, y)
	TimerOFFAlarm.Enable = True
	ImageOFFFresh.Visible = True
	CheckBoxOFFAlarm.Enabled = False
	SetAlmSwitchByCheck()
End Sub
'----------------------------------------------------------------
Sub SetAlmSwitchByCheck()
	nAlmSwitch = 0
	if CheckBoxONAlarm.Value<>0 THEN
		nAlmSwitch = nAlmSwitch + 1
	END IF
	if CheckBoxOFFAlarm.Value<>0 THEN
		nAlmSwitch = nAlmSwitch + 2
	END IF
	Dim tagName
	tagName = Form.TagName("@THIS@.ALMSWITCH")
	Form.WriteTagFromInterface tagName,nAlmSwitch
End Sub

'----------------------------------------------------------------
Sub TimerOnAlarm_OnTimer()
	TimerOnAlarm.Enable = False
	ImageOnFresh.Visible = False
	CheckBoxONAlarm.Enabled = True
End Sub

'----------------------------------------------------------------
Sub TimerOFFAlarm_OnTimer()	
	TimerOFFAlarm.Enable = False
	ImageOFFFresh.Visible = False
	CheckBoxOFFAlarm.Enabled = True
End Sub
