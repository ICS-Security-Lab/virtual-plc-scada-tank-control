TEXT3.Text = Form.TagName("@THIS@")
TEXT4.Text = Form.TagDescription("@THIS@")

IF Form.IsDomainTag("@THIS@") = 1 THEN
	PolygonHH.Visible = False
	PolygonH.Visible = False
	PolygonL.Visible = False
	PolygonLL.Visible = False
	PolygonLLL.Visible = False
	PolygonHHH.Visible = False
	Button8.Visible = False
END IF

Button1.Visible = False
bOtherDomainTag = Form.OtherDomainTag(Form.TagName("@THIS@"))
IF bOtherDomainTag = True THEN
   Button8.Visible = False
END IF
bVxHistorianMode = Form.IsVxHistorianMode()
IF bVxHistorianMode = True THEN
	CheckBoxRate.Visible = False
	DataLinkRate.Visible = False
	CheckBoxORH.Visible = False
	DataLinkORH.Visible = False
	CheckBoxORLOW.Visible = False
	DataLinkORLOW.Visible = False
END IF
a = TAG("@THIS@")
'设置面板位号名称
TrdGraph4.SetPanelTagName Form.TagName("@THIS@")
Timer1_OnTimer()

Dim timerCount

Sub Timer1_OnTimer()
	IF Form.GetTagType("@THIS@") <> 11 Then
		Form.ClosePopPic ""
	Else
		Dim dwQua
	    dwQua = Form.Quality("@THIS@")
	    IF CLng(dwQua)=0 Then
	    	IF Form.Alarm("@THIS@")=True Then
	    		Text6.Text = ""
	    	Else
	    		Text6.Text = "NR"
	    	End IF
	    Else
	        IF timerCount >= 3 THEN
	        	Text6.Text = "RTDATA_BAD"
	        End If
	    End If
	   	IF Form.Alarm("@THIS@") <> False THEN
			Button1.Visible = True
		Else 
			Button1.Visible = False
		END IF
	    ShowAlarm()
	    ShowHistogram()
	        
	    Text1.Text = FormatNumber(Form.TagHLimit("@THIS@"), Form.TagDecimal("@THIS@"), -1)
	    Text2.Text = FormatNumber(Form.TagLLimit("@THIS@"), Form.TagDecimal("@THIS@"), -1)
	    
	    IF Form.IsDomainTag("@THIS@") <> 1 THEN
	    	Text_Unit.Text = Form.Tag("@THIS@.EU")
	    End IF
	End IF
    
    timerCount = timerCount + 1
    EnableAlarmCheck()
    EnableAlarmLimit()
End Sub

Sub ShowAlarm()

	Dim dwQua
	dwQua = Form.Quality("@THIS@")
	
	IF Form.IsDomainTag("@THIS@") = 1 THEN
		IF CLng(dwQua)=0 THEN
			Ellipse1.BackgroundColor = vbGreen
		ELSE
			Ellipse1.BackgroundColor = vbBlack
		END IF
		
		EXIT Sub
	END IF
	
	Dim hhLimit,hLimit,lLimit,llLimit,hhhLimit,lllLimit
	Dim bHH,bH,bL,bLL,bHHH,bLLL
	hhLimit=Form.TagAlarmHH("@THIS@",bHH)
	hLimit=Form.TagAlarmH("@THIS@",bH)
	lLimit=Form.TagAlarmL("@THIS@",bL)
	llLimit=Form.TagAlarmLL("@THIS@",bLL)
	lllLimit=Form.TagAlarm3L("@THIS@",bLLL)
	hhhLimit=Form.TagAlarm3H("@THIS@",bHHH)
	
	IF Form.IsDomainTag("@THIS@") = 0 THEN
		Dim bEnableAlm
		bEnableAlm=Form.Tag("@THIS@.ALMENAB")
		IF bEnableAlm <> 0 And bHH=True THEN
			PolygonHH.Visible = True
		Else 
			PolygonHH.Visible = False
		END IF
		
		IF bEnableAlm <> 0 And bH=True THEN
			PolygonH.Visible = True
		Else 
			PolygonH.Visible = False
		END IF
		
		IF bEnableAlm <> 0 And bL=True THEN
			PolygonL.Visible = True
		Else 
			PolygonL.Visible = False
		END IF
		
		IF bEnableAlm <> 0 And bLL=True THEN
			PolygonLL.Visible = True
		Else 
			PolygonLL.Visible = False
		END IF
		
		IF bEnableAlm <> 0 And bLLL =True THEN
			PolygonLLL.Visible = True
		Else 
			PolygonLLL.Visible = False
		END IF
		
		IF bEnableAlm <> 0 And bHHH =True THEN
			PolygonHHH.Visible = True
		Else 
			PolygonHHH.Visible = False
		END IF
	End If
	
	IF Form.Alarm("@THIS@")=True And CLng(dwQua)=0 THEN
		Dim rtValue
		rtValue=Form.Tag("@THIS@")
		
		Dim rinState
		IF Form.Tag("@THIS@.PRINSTATE") <> False THEN
			rinState = "PRIN "
		ELSEIF Form.Tag("@THIS@.NRINSTATE") <> False THEN
			rinState = "NRIN "
		ELSE
			rinState = ""
		END IF
		
		IF Form.Tag("@THIS@.HHSTATE") <> False THEN
			Ellipse1.BackgroundColor = vbRed
		ELSEIF Form.Tag("@THIS@.HISTATE") <> False THEN
			Ellipse1.BackgroundColor = vbYellow
		ELSEIF Form.Tag("@THIS@.LLSTATE") <> False THEN
			Ellipse1.BackgroundColor = vbRed
		ELSEIF Form.Tag("@THIS@.LOSTATE") <> False THEN
			Ellipse1.BackgroundColor = vbYellow
		ELSEIF Form.Tag("@THIS@.RATESTATE") <> False THEN
			Ellipse1.BackgroundColor = vbRed
		elseif Form.Tag("@THIS@.ORHSTATE") <> False Then
			Ellipse1.BackgroundColor = vbRed
		elseif Form.Tag("@THIS@.ORLSTATE") <> False Then
			Ellipse1.BackgroundColor = vbRed
		elseif Form.Tag("@THIS@.L3STATE") <> False Then
			Ellipse1.BackgroundColor = vbRed
		elseif Form.Tag("@THIS@.H3STATE") <> False Then
			Ellipse1.BackgroundColor = vbRed
		ELSE
			Ellipse1.BackgroundColor = vbGreen
		END IF
		
		Dim HHAlmStat
		HHAlmStat=""
		IF Form.Tag("@THIS@.HHSTATE") <> False THEN
			HHAlmStat="HH "
		End IF
		
		Dim HAlmStat
		HAlmStat=""
		IF Form.Tag("@THIS@.HISTATE") <> False THEN
			HAlmStat="H "
		End IF
		
		Dim LLAlmStat
		LLAlmStat=""
		IF Form.Tag("@THIS@.LLSTATE") <> False THEN
			LLAlmStat="LL "
		End IF
		
		Dim LAlmStat
		LAlmStat=""
		IF Form.Tag("@THIS@.LOSTATE") <> False THEN
			LAlmStat="L "
		End IF
		
		Dim ORHAlmStat
		ORHAlmStat = ""
		IF Form.Tag("@THIS@.ORHSTATE") <> False THEN
			ORHAlmStat="ORH "
		End IF
		
		Dim ORLAlmStat
		ORLAlmStat = ""
		IF Form.Tag("@THIS@.ORLSTATE") <> False THEN
			ORLAlmStat="ORL "
		End IF
		
		Dim HHHAlmStat
		HHHAlmStat = ""
		IF Form.Tag("@THIS@.H3STATE") <> False THEN
			HHHAlmStat="H3 "
		End IF
		
		Dim LLLAlmStat
		LLLAlmStat = ""
		IF Form.Tag("@THIS@.L3STATE") <> False THEN
			LLLAlmStat="L3 "
		End IF
		
		Text5.Text= HAlmStat & HHAlmStat & LAlmStat & LLAlmStat & rinState & ORHAlmStat & ORLAlmStat & HHHAlmStat & LLLAlmStat
		
	ELSEIF CLng(dwQua)=0 THEN
		Text5.Text=""
		Ellipse1.BackgroundColor = vbGreen
	ELSE
		Text5.Text=""
		Ellipse1.BackgroundColor = vbBlack
	END IF

	IF Form.IsDomainTag("@THIS@") = 0 THEN
		Dim hl,ll
		hl = Form.TagHLimit("@THIS@")
		ll = Form.TagLLimit("@THIS@")
		
		IF hhLimit >= hl THEN
			PolygonHH.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF hhLimit <= ll THEN
			PolygonHH.Top = Rect3.Bottom - 3
		ELSE
			PolygonHH.Top = Rect3.Bottom - (Rect3.Height * (hhLimit - ll) / (hl - ll)) - 3
		END IF
		
		IF hLimit >= hl THEN
			PolygonH.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF hLimit <= ll THEN
			PolygonH.Top = Rect3.Bottom - 3
		ELSE
			PolygonH.Top = Rect3.Bottom - (Rect3.Height * (hLimit - ll) / (hl - ll)) - 3
		END IF
		
		IF lLimit >= hl THEN
			PolygonL.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF hLimit <= ll THEN
			PolygonL.Top = Rect3.Bottom - 3
		ELSE
			PolygonL.Top = Rect3.Bottom - (Rect3.Height * (lLimit - ll) / (hl - ll)) - 3
		END IF
		
		IF llLimit >= hl THEN
			PolygonLL.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF llLimit <= ll THEN
			PolygonLL.Top = Rect3.Bottom - 3
		ELSE
			PolygonLL.Top = Rect3.Bottom - (Rect3.Height * (llLimit - ll) / (hl - ll)) - 3
		END IF	
		
		IF lllLimit >= hl THEN
			PolygonLLL.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF lllLimit <= ll THEN
			PolygonLLL.Top = Rect3.Bottom - 3
		ELSE
			PolygonLLL.Top = Rect3.Bottom - (Rect3.Height * (lllLimit - ll) / (hl - ll)) - 3
		END IF
		
		IF hhhLimit >= hl THEN
			PolygonHHH.Top = Rect3.Bottom - Rect3.Height - 3
		ELSEIF hhLimit <= ll THEN
			PolygonHHH.Top = Rect3.Bottom - 3
		ELSE
			PolygonHHH.Top = Rect3.Bottom - (Rect3.Height * (hhhLimit - ll) / (hl - ll)) - 3
		END IF	
		
	End IF	

End Sub

Sub ShowHistogram()
	Dim dwQua,hl,ll
	dwQua = Form.Quality("@THIS@")
	hl = Form.TagHLimit("@THIS@")
	ll = Form.TagLLimit("@THIS@")
	
	If CLng(dwQua) = 0 Then
		rtValue = Form.Tag("@THIS@")
		
		If Form.Alarm("@THIS@") = True Then	
			If Form.Tag("@THIS@.HHSTATE") <> False Then
				Rect5.BackgroundColor = vbRed
			ELSEIF Form.Tag("@THIS@.HISTATE") <> False THEN
				Rect5.BackgroundColor = vbYellow
			ELSEIF Form.Tag("@THIS@.LLSTATE") <> False THEN
				Rect5.BackgroundColor = vbRed
			ELSEIF Form.Tag("@THIS@.LOSTATE") <> False THEN
				Rect5.BackgroundColor = vbYellow
			ELSEIF Form.Tag("@THIS@.ORHSTATE") <> False THEN
				Rect5.BackgroundColor = vbRed
			ELSEIF Form.Tag("@THIS@.ORLSTATE") <> False THEN
				Rect5.BackgroundColor = vbRed
			ELSEIF Form.Tag("@THIS@.H3STATE") <> False THEN
				Rect5.BackgroundColor = vbRed
			ELSEIF Form.Tag("@THIS@.L3STATE") <> False THEN
				Rect5.BackgroundColor = vbRed
			ELSE
				Rect5.BackgroundColor = vbGreen
			END IF
		Else
			Rect5.BackgroundColor = vbGreen
		End If
		
		IF hl <= ll Or rtValue > hl Then
			Rect5.Height = Rect3.Height
		ElseIf rtValue < ll Then
			Rect5.Height = 0
		Else
			Rect5.Height = Rect3.Height * (rtValue - ll) / (hl - ll)
		End If

		Rect5.Bottom = Rect3.Bottom
	Else
		Rect5.BackgroundColor = vbBlack
		Rect5.Height = 0
		Rect5.Bottom = Rect3.Bottom
	End If
End Sub
'----------------------------------------------------------------
Sub EnableAlarmCheck()
	Dim bEnableAlm
	bEnableAlm = Form.Tag("@THIS@.ALMENAB")
	CheckBoxL.Enabled = bEnableAlm
	CheckBoxLL.Enabled = bEnableAlm
	CheckBoxL3.Enabled = bEnableAlm
	CheckBoxH.Enabled = bEnableAlm
	CheckBoxHH.Enabled = bEnableAlm
	CheckBoxH3.Enabled = bEnableAlm
	CheckBoxRate.Enabled = bEnableAlm
	CheckBoxORH.Enabled = bEnableAlm
	CheckBoxORLOW.Enabled = bEnableAlm
End Sub
'----------------------------------------------------------------
Sub EnableAlarmLimit()
	Dim bEnableAlm
	bEnableAlm = Form.Tag("@THIS@.ALMENAB")
	IF CheckBoxL.Value=1 And bEnableAlm THEN
		DataLinkL.Enabled = True
	ELSE
		DataLinkL.Enabled = False
	END IF
	IF CheckBoxLL.Value=1 And bEnableAlm THEN
		DataLinkLL.Enabled = True
	ELSE
		DataLinkLL.Enabled = False
	END IF
	IF CheckBoxL3.Value=1 And bEnableAlm THEN
		DataLinkL3.Enabled = True
	ELSE
		DataLinkL3.Enabled = False
	END IF
	IF CheckBoxH.Value=1 And bEnableAlm THEN
		DataLinkH.Enabled = True
	ELSE
		DataLinkH.Enabled = False
	END IF
	IF CheckBoxHH.Value=1 And bEnableAlm THEN
		DataLinkHH.Enabled = True
	ELSE
		DataLinkHH.Enabled = False
	END IF
	IF CheckBoxH3.Value=1 And bEnableAlm THEN
		DataLinkH3.Enabled = True
	ELSE
		DataLinkH3.Enabled = False
	END IF
	IF CheckBoxRate.Value=1 And bEnableAlm THEN
		DataLinkRate.Enabled = True
	ELSE
		DataLinkRate.Enabled = False
	END IF
	IF CheckBoxORH.Value=1 And bEnableAlm THEN
		DataLinkORH.Enabled = True
	ELSE
		DataLinkORH.Enabled = False
	END IF
	IF CheckBoxORLOW.Value=1 And bEnableAlm THEN
		DataLinkORLOW.Enabled = True
	ELSE
		DataLinkORLOW.Enabled = False
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxH3_OnLButtonDown(nFlag, x, y)
	if CheckBoxH3.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.H3")
		strTagName = Form.TagName("@THIS@.H3")
		If (Form.Tag("@THIS@.HHENAB") <> False) And (Form.Tag("@THIS@.HH")>DomainValue) Then		
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HH")
		ELSEIF (Form.Tag("@THIS@.HIENAB") <> False) And (Form.Tag("@THIS@.HI")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HI")			
		ELSEIF (Form.Tag("@THIS@.LOENAB") <> False) And (Form.Tag("@THIS@.LO")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LO")
		ELSEIF (Form.Tag("@THIS@.LLENAB") <> False) And (Form.Tag("@THIS@.LL")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LL")
		ELSEIF (Form.Tag("@THIS@.L3ENAB") <> False) And (Form.Tag("@THIS@.L3")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.L3")
		END IF
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxHH_OnLButtonDown(nFlag, x, y)
	if CheckBoxHH.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.HH")
		strTagName = Form.TagName("@THIS@.HH")
		If (Form.Tag("@THIS@.H3ENAB") <> False) And (DomainValue>Form.Tag("@THIS@.H3")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.H3")
		ELSEIF (Form.Tag("@THIS@.HIENAB") <> False) And (Form.Tag("@THIS@.HI")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HI")			
		ELSEIF (Form.Tag("@THIS@.LOENAB") <> False) And (Form.Tag("@THIS@.LO")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LO")
		ELSEIF (Form.Tag("@THIS@.LLENAB") <> False) And (Form.Tag("@THIS@.LL")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LL")
		ELSEIF (Form.Tag("@THIS@.L3ENAB") <> False) And (Form.Tag("@THIS@.L3")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.L3")
		END IF
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxH_OnLButtonDown(nFlag, x, y)
	if CheckBoxH.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.HI")
		strTagName = Form.TagName("@THIS@.HI")
		If (Form.Tag("@THIS@.HHENAB") <> False) And (DomainValue>Form.Tag("@THIS@.HH")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HH")
		ELSEIF (Form.Tag("@THIS@.H3ENAB") <> False) And (DomainValue>Form.Tag("@THIS@.H3")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.H3")			
		ELSEIF (Form.Tag("@THIS@.LOENAB") <> False) And (Form.Tag("@THIS@.LO")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LO")
		ELSEIF (Form.Tag("@THIS@.LLENAB") <> False) And (Form.Tag("@THIS@.LL")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LL")
		ELSEIF (Form.Tag("@THIS@.L3ENAB") <> False) And (Form.Tag("@THIS@.L3")>DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.L3")
		END IF
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxL_OnLButtonDown(nFlag, x, y)
	if CheckBoxL.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.LO")
		strTagName = Form.TagName("@THIS@.LO")
		If (Form.Tag("@THIS@.LLENAB") <> False) And (DomainValue<Form.Tag("@THIS@.LL")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LL")
		ELSEIF (Form.Tag("@THIS@.L3ENAB") <> False) And (DomainValue<Form.Tag("@THIS@.L3")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.L3")			
		ELSEIF (Form.Tag("@THIS@.HIENAB") <> False) And (Form.Tag("@THIS@.HI")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HI")
		ELSEIF (Form.Tag("@THIS@.HHENAB") <> False) And (Form.Tag("@THIS@.HH")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HH")
		ELSEIF (Form.Tag("@THIS@.H3ENAB") <> False) And (Form.Tag("@THIS@.H3")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.H3")
		END IF
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxLL_OnLButtonDown(nFlag, x, y)
	if CheckBoxLL.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.LL")
		strTagName = Form.TagName("@THIS@.LL")
		If (Form.Tag("@THIS@.LOENAB") <> False) And (Form.Tag("@THIS@.LO")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LO")
		ELSEIF (Form.Tag("@THIS@.L3ENAB") <> False) And (DomainValue<Form.Tag("@THIS@.L3")) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.L3")			
		ELSEIF (Form.Tag("@THIS@.HIENAB") <> False) And (Form.Tag("@THIS@.HI")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HI")
		ELSEIF (Form.Tag("@THIS@.HHENAB") <> False) And (Form.Tag("@THIS@.HH")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HH")
		ELSEIF (Form.Tag("@THIS@.H3ENAB") <> False) And (Form.Tag("@THIS@.H3")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.H3")
		END IF
	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBoxL3_OnLButtonDown(nFlag, x, y)
	if CheckBoxL3.Value<>1 THEN
		DomainValue = Form.Tag("@THIS@.L3")
		strTagName = Form.TagName("@THIS@.L3")
		If (Form.Tag("@THIS@.LLENAB") <> False) And (Form.Tag("@THIS@.LL")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LL")
		ELSEIF (Form.Tag("@THIS@.LOENAB") <> False) And (Form.Tag("@THIS@.LO")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.LO")			
		ELSEIF (Form.Tag("@THIS@.HIENAB") <> False) And (Form.Tag("@THIS@.HI")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HI")
		ELSEIF (Form.Tag("@THIS@.HHENAB") <> False) And (Form.Tag("@THIS@.HH")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.HH")
		ELSEIF (Form.Tag("@THIS@.H3ENAB") <> False) And (Form.Tag("@THIS@.H3")<DomainValue) Then
			Form.WriteTagFromInterface strTagName,Form.Tag("@THIS@.H3")
		END IF
	END IF	
End Sub