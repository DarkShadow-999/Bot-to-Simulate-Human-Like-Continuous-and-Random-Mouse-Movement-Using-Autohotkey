#SingleInstance,Force
SetBatchLines,-1
CoordMode,Mouse,Screen

stop = 0
Start:=New HB_Vector(400,400)

Gui,1:+AlwaysOnTop
Gui,1:Add,Text,xm y+10 ,Mag1: 
Gui,1:Add,Edit,x+10 w350 r1 vMag1 gSubmitAll,1
Gui,1:Add,Text,xm y+10 ,Mag2: 
Gui,1:Add,Edit,x+10 w350 r1 vMag2 gSubmitAll,.4
Gui,1:Show,x50 y50,Set Start And End Points
gosub,SubmitAll
return
GuiClose:
GuiContextMenu:
*ESC::
	Confine := !Confine
	ClipCursor( Confine, 100, 100, A_ScreenWidth-100, A_ScreenHeight-100 )
	ExitApp

*Numpad4::Reload
	
*Numpad5::WinMinimize
	
SubmitAll:
	Gui,1:Submit,NoHide
	return

*Numpad1::
*z::
Loop
	If stop = 0
	{
		Confine := !Confine
		ClipCursor( Confine, 100, 200, A_ScreenWidth-100, A_ScreenHeight-100 )
			; ToolTip, %A_Index%
			Sleep, 1
	
	loop
	{
	
	Random, x1,0, 1340
	Random, y1,0, 655


	End:=New HB_Vector(x1,y1)
	Pos:=New HB_Vector(Start.X,Start.Y)
	Starting_Target:=New HB_Vector(Random(Start.X-20,Start.X+20),Random(Start.y-20,Start.y+20))
	if(abs(Start.X-End.X)>=abs(Start.Y-End.Y)){
		;~ Max_X_Vel:=15,Max_Y_Vel:=8
		Max_X_Vel:=30,Max_Y_Vel:=16
		Vel:=New HB_Vector(Random(7,16),Random(-5,5))
		New_Vec:=New HB_Vector(Random(End.X-(abs(Start.X-End.X)*.2),End.X+(abs(Start.X-End.X)*.2)),Random(End.Y-(abs(Start.X-End.X)*.03),End.Y+(abs(Start.X-End.X)*.03)))
	}else {
		Max_X_Vel:=8,Max_Y_Vel:=15
		;~ Vel:=New HB_Vector(0,5)
		Vel:=New HB_Vector(Random(-5,5),Random(-5,10))
		New_Vec:=New HB_Vector(Random(End.X-(abs(Start.X-End.X)*.01),End.X+(abs(Start.X-End.X)*.01)),Random(End.Y-(abs(Start.X-End.X)*.3),End.Y+(abs(Start.X-End.X)*.3)))
	}
	Acc:=New HB_Vector(0,0)
	MouseMove,Start.X,Start.Y
	count:=0
	While((Pos.dist(Starting_Target)>10||Count<2)&&Count<3){
		Count++
		Acc.X:=Starting_Target.X,Acc.Y:=Starting_Target.Y
		Acc.Sub(Pos),Acc.SetMag(Mag1),Vel.Add(Acc)
		Check_Speed(vel,Max_X_Vel,Max_Y_Vel)
		Pos.Add(Vel)
		MouseMove,Pos.X,Pos.Y,0
	}
	Count:=0
	;~ While(Pos.dist(New_Vec)>Random(30,200)){
	While(Pos.dist(New_Vec)>Random(30,100)){
		if(++Count>44){
			Vel.X*=.9
			Vel.Y*=.9
			Count:=0
		}
		Acc.X:=New_Vec.X,Acc.Y:=New_Vec.Y
		Acc.Sub(Pos),Acc.SetMag(Mag1),Vel.Add(Acc)
		Check_Speed(vel,Max_X_Vel,Max_Y_Vel)
		Pos.Add(Vel)
		MouseMove,Pos.X,Pos.Y,0
	}
	Vel.X*=0.01,Vel.Y*=0.1
	count:=0
	While(Pos.dist(New_Vec)>32){
		if(++Count>15){
			Vex.X*=.9
			Vex.Y*=.9
			Count:=0
		}
		Acc.X:=New_Vec.X,Acc.Y:=New_Vec.Y
		Acc.Sub(Pos),Acc.SetMag(Mag1),Vel.Add(Acc)
		Check_Speed(vel,Max_X_Vel,Max_Y_Vel)
		Pos.Add(Vel)
		MouseMove,Pos.X,Pos.Y,0
	}
	Vel.X:=0,Vel.Y:=0,count:=0
	While(Pos.dist(End)>28){
		if(++Count>40)
			Vel.X*=.8,Vel.Y*=.8,count:=0
		Acc.X:=End.X,Acc.Y:=End.Y
		Acc.Sub(Pos),Acc.SetMag(Mag2),Vel.Add(Acc)
		Check_Speed(vel,Max_X_Vel,Max_Y_Vel)
		Pos.Add(Vel)
		MouseMove,Pos.X,Pos.Y,0
	}
	;~ return
	Vel.X:=0,Vel.Y:=0,count:=0
	While(Pos.dist(End)>3){
		if(++Count>5)
			Vel.X*=.5,Vel.Y*=.5,count:=0
		Acc.X:=End.X,Acc.Y:=End.Y
		Acc.Sub(Pos),Acc.SetMag(Mag2),Vel.Add(Acc)
		Check_Speed(vel,Max_X_Vel,Max_Y_Vel)
		Pos.Add(Vel)
		MouseMove,Pos.X,Pos.Y,0
	}
	MouseMove,End.X,End.Y,0
	Start:=New HB_Vector(x1,y1)
	}
	return
	}
return
	
Check_Speed(vel,max_velX,Max_VelY){
	(vel.X>max_VelX)?(vel.x:=max_VelX),(vel.x<-max_VelX)?(vel.x:=-max_VelX)
	(vel.y>max_VelY)?(vel.y:=max_VelY),(vel.y<-max_VelY)?(vel.y:=-max_VelY)
}

Random(Min,Max){
	Random,Out,Min,Max
	return Out
}

ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ){
	VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
	Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
}


Class HB_Vector	{
	__New(x:=0,y:=0){
		This.X:=x
		This.Y:=y
	}
	Add(Other_HB_Vector){
		This.X+=Other_HB_Vector.X
		This.Y+=Other_HB_Vector.Y
	}
	Sub(Other_HB_Vector){
		This.X-=Other_HB_Vector.X
		This.Y-=Other_HB_Vector.Y
	}
	mag(){
		return Sqrt(This.X*This.X + This.Y*This.Y)
	}
	magsq(){
		return This.Mag()**2
	}	
	setMag(in1){
		m:=This.Mag()
		This.X := This.X * in1/m
		This.Y := This.Y * in1/m
		return This
	}
	mult(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X*=In1.X 
			This.Y*=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X*=In1
			This.Y*=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X*=In1*In2.X
			This.Y*=In1*In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X*=In1.X*In2.X
			This.Y*=In1.Y*In2.Y
		}	
	}
	div(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X/=In1.X 
			This.Y/=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X/=In1
			This.Y/=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X/=In1/In2.X
			This.Y/=In1/In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X/=In1.X/In2.X
			This.Y/=In1.Y/In2.Y
		}	
	}
	dist(in1){
		return Sqrt(((This.X-In1.X)**2) + ((This.Y-In1.Y)**2))
	}
	dot(in1){
		return (This.X*in1.X)+(This.Y*In1.Y)
	}
	cross(in1){
		return This.X*In1.Y-This.Y*In1.X
	}
	Norm(){
		m:=This.Mag()
		This.X/=m
		This.Y/=m
	}
}
