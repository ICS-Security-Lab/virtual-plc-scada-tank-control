Text1.Text = Form.TagName("@THIS@")
Text7.Text = Form.TagDescription("@THIS@")

'----------------------------------------------------------------
Sub Timer1_OnTimer()
    dwQua = Form.Quality("@THIS@.IN")
    IF CLng(dwQua)=0 Then
    	Ellipse1.BackgroundColor = vbGreen
    	IF Form.Alarm("@THIS@.IN")=True THEN
    		Ellipse1.BackgroundColor = vbRed	
		END IF
    	Text2.Text = "NR"
    Else
        Ellipse1.BackgroundColor = vbBlack
        Text2.Text = "RTDATA_BAD"
    End If 
    ShowAlarm()
End Sub

Sub ShowAlarm()
dwQua = Form.Quality("@THIS@.IN")
IF Form.Alarm("@THIS@.IN")=True And CLng(dwQua)=0 THEN
	If Form.Tag("@THIS@.IN") = True Then
		Text3.Text="ON"
	ELSE
		Text3.Text="OFF"
	End IF
ELSE
	Text3.Text=""	
END IF
End Sub