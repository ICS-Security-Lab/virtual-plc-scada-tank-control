TEXT3.Text = Form.TagName("@THIS@")
TEXT10.Text = Form.TagDescription("@THIS@")

c = Tag("@THIS@.MV")
TrdGraph1.SetTagLimitVal 100, 0, 0
'----------------------------------------------------------------
Sub Button6_OnLButtonUp(nFlag, x, y)
    Dim dwQua
    dwQua = Form.Quality("@THIS@.MV")
    Ellipse1.BackgroundColor = vbGreen
End Sub

'----------------------------------------------------------------
Sub Timer1_OnTimer()
    dwQua = Form.Quality("@THIS@.MV")
    IF CLng(dwQua)=0 Then
    	Ellipse1.BackgroundColor = vbGreen
    	IF Form.Alarm("@THIS@.MV")=True THEN
    		Ellipse1.BackgroundColor = vbRed	
		END IF
    	Text12.Text = "NR"
    Else
        Ellipse1.BackgroundColor = vbBlack
        Text12.Text = "RTDATA_BAD"
    End If
    
    ShowAlarm()
End Sub

Sub ShowAlarm()
dwQua = Form.Quality("@THIS@.MV")
IF Form.Alarm("@THIS@.MV")=True And CLng(dwQua)=0 THEN
	Dim hhLimit,hLimit,lLimit,llLimit,rtValue
	Dim bHH,bH,bL,bLL
	hhLimit=Form.TagAlarmHH("@THIS@.MV",bHH)
	hLimit=Form.TagAlarmH("@THIS@.MV",bH)
	lLimit=Form.TagAlarmL("@THIS@.MV",bL)
	llLimit=Form.TagAlarmLL("@THIS@.MV",bLL)
	rtValue=Form.Tag("@THIS@.MV")
	
	IF bHH=True And rtValue>=hhLimit THEN
		Text11.Text="H HH" 	

	ELSEIF bH=True And rtValue>=hLimit THEN
		Text11.Text="H" 
		
	ELSEIF bLL=True And rtValue<=llLimit THEN
		Text11.Text="L LL" 	
		
	ELSEIF bL=True And rtValue<=lLimit THEN
		Text11.Text="L" 
	ELSE
		Text11.Text="" 
	END IF	
ELSE
	Text11.Text=""	
END IF
End Sub