PPM.Pony_variables=PPM.Pony_variables or {}

PPM.Pony_variables.default_pony={
	--main
	kind={default=4,min=1,max=4},
	age={default=2,min=2,max=2},
	gender={default=1,min=1,max=2},
	body_type={default=1,min=1,max=1},
	
	--body
	_cmark={default=nil},
	_cmark_loaded={default=false},
	mane={default=1,min=1,max=15},
	manel={default=1,min=1,max=12},
	tail={default=1,min=1,max=14},
	tailsize={default=1,min=0.8,max=1},
	 
	cmark_enabled={default=2},
	cmark={default=1,min=1,max=30},
	custom_mark={default=nil},
	bodyweight={default=1,min=0.8,max=1.2},

	--coat and horn
	coatcolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	horncolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	wingcolor={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},

	--shinyness
	wingphongexponent={default=6,min=0,max=255},
	wingphongboost={default=.05,min=0,max=255},
	hairphongexponent={default=6,min=0,max=255},
	hairphongboost={default=1,min=0,max=255},
	manephongexponent={default=6,min=0,max=255},
	manephongboost={default=1,min=0,max=255},
	tailphongexponent={default=6,min=0,max=255},
	tailphongboost={default=.5,min=0,max=255},
	coatphongexponent={default=.5,min=0,max=255},
	coatphongboost={default=.6,min=0,max=255},
	hornphongexponent={default=.1,min=0,max=255},
	hornphongboost={default=.1,min=0,max=255},

	--upper mane
	haircolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	haircolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},

	--lower mane
	manecolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	manecolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},

	--tail
	tailcolor1={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor2={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor3={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor4={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor5={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},
	tailcolor6={default=Vector(1,1,1),min=Vector(0,0,0),max=Vector(1,1,1)},

	--bodydetails
	bodydetail1={default=1},
	bodydetail2={default=1},
	bodydetail3={default=1},
	bodydetail4={default=1},
	bodydetail5={default=1},
	bodydetail6={default=1},
	bodydetail7={default=1},
	bodydetail8={default=1},
	
	bodydetail1_c={default=Vector(1,1,1)},
	bodydetail2_c={default=Vector(1,1,1)},
	bodydetail3_c={default=Vector(1,1,1)},
	bodydetail4_c={default=Vector(1,1,1)},
	bodydetail5_c={default=Vector(1,1,1)},
	bodydetail6_c={default=Vector(1,1,1)},
	bodydetail7_c={default=Vector(1,1,1)},
	bodydetail8_c={default=Vector(1,1,1)},
--[[
	bodydetail1phongexponent={default=1,min=0,max=255},
	bodydetail2phongexponent={default=1,min=0,max=255},
	bodydetail3phongexponent={default=1,min=0,max=255},
	bodydetail4phongexponent={default=1,min=0,max=255},
	bodydetail5phongexponent={default=1,min=0,max=255},
	bodydetail6phongexponent={default=1,min=0,max=255},
	bodydetail7phongexponent={default=1,min=0,max=255},
	bodydetail8phongexponent={default=1,min=0,max=255},

	bodydetail1phongboost={default=1,min=0,max=255},
	bodydetail2phongboost={default=1,min=0,max=255},
	bodydetail3phongboost={default=1,min=0,max=255},
	bodydetail4phongboost={default=1,min=0,max=255},
	bodydetail5phongboost={default=1,min=0,max=255},
	bodydetail6phongboost={default=1,min=0,max=255},
	bodydetail7phongboost={default=1,min=0,max=255},
	bodydetail8phongboost={default=1,min=0,max=255},--]]
	--left eye
	eyehaslines={default=1},	
	eyelash={default=1,min=1,max=5},
	eyeirissize={default=0.7,min=0.65,max=0.88},
	eyeholesize={default=0.7,min=0.65,max=0.88},
	eyejholerssize={default=1,min=0.2,max=1},
	eyecolor_bg={default=Vector(1,1,1)},
	eyecolor_iris={default=Vector(1,1,1)/3},
	eyecolor_grad={default=Vector(.5,.5,.5)},
	eyecolor_line1={default=Vector(.8,.8,.8)},
	eyecolor_line2={default=Vector(.9,.9,.9)},
	eyecolor_hole={default=Vector(0,0,0)},

	--right eye
	eyehaslines_r={default=1},
	eyelash_r={default=1,min=1,max=5},
	eyeirissize_r={default=0.7,min=0.65,max=0.88},
	eyeholesize_r={default=0.7,min=0.65,max=0.88},
	eyejholerssize_r={default=1,min=0.2,max=1},
	eyecolor_bg_r={default=Vector(1,1,1)},
	eyecolor_iris_r={default=Vector(1,1,1)/3},
	eyecolor_grad_r={default=Vector(.5,.5,.5)},
	eyecolor_line1_r={default=Vector(.8,.8,.8)},
	eyecolor_line2_r={default=Vector(.9,.9,.9)},
	eyecolor_hole_r={default=Vector(0,0,0)},	

	--body clothing
	bodyt0={default=1},
	--bodyt1={default=1},
	--bodyt2={default=1},
}
