Text14.Text = Form.TagDescription("@THIS@")
Text7.Text = Form.TagName("@THIS@")
a = Tag("@THIS@.OUT")
'----------------------------------------------------------------
Sub Timer1_OnTimer()
    dwQua = Form.Quality("@THIS@.OUT")
    IF CLng(dwQua)=0 Then
    	Ellipse2.BackgroundColor = vbGreen
    	IF Form.Alarm("@THIS@.OUT")=True THEN
    		Ellipse2.BackgroundColor = vbRed	
		END IF
    	Text8.Text = "NR"
    Else
        Ellipse2.BackgroundColor = vbBlack
        Text8.Text = "RTDATA_BAD"
    End If 
    ShowAlarm()
End Sub
'----------------------------------------------------------------
Sub ShowAlarm()
dwQua = Form.Quality("@THIS@.OUT")
IF Form.Alarm("@THIS@.OUT")=True And CLng(dwQua)=0 THEN
	If Form.Tag("@THIS@.OUT") = True Then
		Text9.Text="ON"
	ELSE
		Text9.Text="OFF"
	End IF
ELSE
	Text9.Text=""	
END IF
End Sub