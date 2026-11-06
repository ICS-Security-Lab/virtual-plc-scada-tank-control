Text1.Text = Form.TagName("@THIS@")
Text7.Text = Form.TagDescription("@THIS@")

Dim timerCount

a = TAG("@THIS@")

Timer1_OnTimer()
'----------------------------------------------------------------
Sub Timer1_OnTimer()
	IF Form.GetTagType("@THIS@") <> 14 Then
		Form.ClosePopPic ""
	Else
		dwQua = Form.Quality("@THIS@")
	    IF CLng(dwQua)=0 Then
	    	Ellipse1.BackgroundColor = vbGreen
	    	IF Form.Alarm("@THIS@")=True THEN
	    		Ellipse1.BackgroundColor = vbRed	
			END IF
	    	Text2.Text = "NR"
	    Else
	        Ellipse1.BackgroundColor = vbBlack
	        IF timerCount >= 3 THEN
	        	Text2.Text = "RTDATA_BAD"
	        End If
	    End If  
	End If

    timerCount = timerCount + 1
End Sub
