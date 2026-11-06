TEXT15.Text = Form.TagName("@THIS@")
TEXT16.Text = Form.TagDescription("@THIS@")
CHECKBOX1.Value=0
CHECKBOX2.Value=0
CHECKBOX3.Value=0
CHECKBOX4.Value=0
CHECKBOX5.Value=0
CHECKBOX6.Value=0
CHECKBOX7.Value=0
CHECKBOX8.Value=0

DataLink5.Enabled=FALSE
DataLink6.Enabled=FALSE
DataLink7.Enabled=FALSE
DataLink8.Enabled=FALSE
DataLink9.Enabled=FALSE
DataLink10.Enabled=FALSE
DataLink11.Enabled=FALSE
DataLink12.Enabled=FALSE

a = Tag("@THIS@.MANMV")
b = Tag("@THIS@.SV")
c = Tag("@THIS@.CSV")
TrdGraph1.SetTagLimitVal 100, 0, 0
TrdGraph1.SetTagLimitVal 100, 0, 1
TrdGraph1.SetTagLimitVal 100, 0, 2
	
'----------------------------------------------------------------
'----------------------------------------------------------------
Sub Timer1_OnTimer()
    dwQua = Form.Quality("@THIS@.PV")
    IF CLng(dwQua)=0 Then
    	Ellipse1.BackgroundColor = vbGreen
    	IF Form.Alarm("@THIS@.PV")=True THEN
    		Ellipse1.BackgroundColor = vbRed	
		END IF
    Else
        Ellipse1.BackgroundColor = vbBlack
        Text18.Text = "RTDATA_BAD"
    End If  
    ShowAlarm()
End Sub

'----------------------------------------------------------------
Sub Button9_OnLButtonUp(nFlag, x, y)
	SELECT CASE Form.Tag("@THIS@.MODE")
	       CASE 4  'MAN
	            Form.Tag("@THIS@.MANMV")=Form.Tag("@THIS@.MANMV")+5
	       CASE 5  'AUTO
	            Form.Tag("@THIS@.SV")=Form.Tag("@THIS@.SV")+5
	       CASE 6  'CAS
	            Form.Tag("@THIS@.CSV")=Form.Tag("@THIS@.CSV")+5
	       CASE ELSE
	END SELECT
End Sub

'----------------------------------------------------------------
Sub Button10_OnLButtonUp(nFlag, x, y)
	SELECT CASE Form.Tag("@THIS@.MODE")
	       CASE 4  'MAN
	            Form.Tag("@THIS@.MANMV")=Form.Tag("@THIS@.MANMV")+1
	       CASE 5  'AUTO
	            Form.Tag("@THIS@.SV")=Form.Tag("@THIS@.SV")+1
	       CASE 6  'CAS
	            Form.Tag("@THIS@.CSV")=Form.Tag("@THIS@.CSV")+1
	       CASE ELSE
	END SELECT	
End Sub

'----------------------------------------------------------------
Sub Button11_OnLButtonUp(nFlag, x, y)
	SELECT CASE Form.Tag("@THIS@.MODE")
	       CASE 4  'MAN
	            Form.Tag("@THIS@.MANMV")=Form.Tag("@THIS@.MANMV")-1
	       CASE 5  'AUTO
	            Form.Tag("@THIS@.SV")=Form.Tag("@THIS@.SV")-1
	       CASE 6  'CAS
	            Form.Tag("@THIS@.CSV")=Form.Tag("@THIS@.CSV")-1
	       CASE ELSE
	END SELECT	
End Sub

'----------------------------------------------------------------
Sub Button12_OnLButtonUp(nFlag, x, y)
	SELECT CASE Form.Tag("@THIS@.MODE")
	       CASE 4  'MAN
	            Form.Tag("@THIS@.MANMV")=Form.Tag("@THIS@.MANMV")-5
	       CASE 5  'AUTO
	            Form.Tag("@THIS@.SV")=Form.Tag("@THIS@.SV")-5
	       CASE 6  'CAS
	            Form.Tag("@THIS@.CSV")=Form.Tag("@THIS@.CSV")-5
	       CASE ELSE
	END SELECT		
End Sub


'----------------------------------------------------------------
Sub CheckBox1_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX1.Value=1 THEN
    	   DataLink5.Enabled=TRUE
    	ELSE
    	   DataLink5.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox2_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX2.Value=1 THEN
    	   DataLink6.Enabled=TRUE
    	ELSE
    	   DataLink6.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox3_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX3.Value=1 THEN
    	   DataLink7.Enabled=TRUE
    	ELSE
    	   DataLink7.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox4_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX4.Value=1 THEN
    	   DataLink8.Enabled=TRUE
    	ELSE
    	   DataLink8.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox5_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX5.Value=1 THEN
    	   DataLink9.Enabled=TRUE
    	ELSE
    	   DataLink9.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox6_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX6.Value=1 THEN
    	   DataLink10.Enabled=TRUE
    	ELSE
    	   DataLink10.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox7_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX7.Value=1 THEN
    	   DataLink11.Enabled=TRUE
    	ELSE
    	   DataLink11.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
Sub CheckBox8_OnLButtonUp(nFlag, x, y)
    	IF CHECKBOX8.Value=1 THEN
    	   DataLink12.Enabled=TRUE
    	ELSE
    	   DataLink12.Enabled=FALSE
    	END IF
End Sub

'----------------------------------------------------------------
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
		Text17.Text="H HH" 	

	ELSEIF bH=True And rtValue>=hLimit THEN
		Text17.Text="H" 
		
	ELSEIF bLL=True And rtValue<=llLimit THEN
		Text17.Text="L LL" 
		
	ELSEIF bL=True And rtValue<=lLimit THEN
		Text17.Text="L" 	
	ELSE
		Text17.Text="" 
	END IF	
ELSE
	Text17.Text=""	
END IF
End Sub