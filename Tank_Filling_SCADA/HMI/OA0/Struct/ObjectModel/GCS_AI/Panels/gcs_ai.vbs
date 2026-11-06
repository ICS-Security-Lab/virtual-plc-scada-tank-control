TEXT3.Text = Form.TagName("@THIS@")
TEXT4.Text = Form.TagDescription("@THIS@")

a = TAG("@THIS@.PV")
TrdGraph1.SetTagLimitVal 100, 0, 0
'----------------------------------------------------------------
Sub Button6_OnLButtonUp(nFlag, x, y)
    Dim dwQua
    dwQua = Form.Quality("@THIS@.PV")
    Ellipse1.BackgroundColor = vbGreen
End Sub

'----------------------------------------------------------------
Sub Timer1_OnTimer()
    dwQua = Form.Quality("@THIS@.PV")
    IF CLng(dwQua)=0 Then
    	Ellipse1.BackgroundColor = vbGreen
    	IF Form.Alarm("@THIS@.PV")=True THEN
    		Ellipse1.BackgroundColor = vbRed	
		END IF
    	Text6.Text = "NR"
    Else
        Ellipse1.BackgroundColor = vbBlack
        Text6.Text = "RTDATA_BAD"
    End If
    ShowAlarm()
    
End Sub

Sub ShowAlarm()
dwQua = Form.Quality("@THIS@.PV")
IF Form.Alarm("@THIS@.PV")=True And CLng(dwQua)=0 THEN
	Dim hhLimit,hLimit,lLimit,llLimit,rtValue
	Dim bHH,bH,bL,bLL
	hhLimit=Form.TagAlarmHH("@THIS@.PV",bHH)
	hLimit=Form.TagAlarmH("@THIS@.PV",bH)
	lLimit=Form.TagAlarmL("@THIS@.PV",bL)
	llLimit=Form.TagAlarmLL("@THIS@.PV",bLL)
	rtValue=Form.Tag("@THIS@.PV")
	
	IF bHH=True And rtValue>=hhLimit THEN
		Text5.Text="H HH" 	

	ELSEIF bH=True And rtValue>=hLimit THEN
		Text5.Text="H" 
		
	ELSEIF bLL=True And rtValue<=llLimit THEN
		Text5.Text="L LL" 
		
	ELSEIF bL=True And rtValue<=lLimit THEN
		Text5.Text="L" 
	ELSE
		Text5.Text="" 
	END IF	
ELSE
	Text5.Text=""	
END IF
End Sub