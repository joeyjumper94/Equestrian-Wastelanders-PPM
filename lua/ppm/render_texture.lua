if CLIENT then
	function PPM.TextureIsOutdated(ent, name, newhash)
		if not PPM.isValidPony(ent) then return true end
		if ent.ponydata_tex==nil then return true end
		if ent.ponydata_tex[name]==nil then return true end
		if ent.ponydata_tex[name .. "_hash"]==nil then return true end
		if ent.ponydata_tex[name .. "_hash"] ~=newhash then return true end

		return false
	end
	function PPM.GetBodyHash(ponydata)
		return tostring(ponydata.bodyt0) .. tostring(ponydata.bodyt1) .. tostring(ponydata.coatcolor) .. tostring(ponydata.bodyt1_color)
	end

	function FixVertexLitMaterial(Mat)
		local strImage=Mat:GetName()

		if (string.find(Mat:GetShader(), "VertexLitGeneric") or string.find(Mat:GetShader(), "Cable")) then
			local t=Mat:GetString("$basetexture")

			if (t) then
				local params={}
				params["$basetexture"]=t
				params["$vertexcolor"]=1
				params["$vertexalpha"]=1
				Mat=CreateMaterial(strImage .. "_DImage", "UnlitGeneric", params)
			end
		end

		return Mat
	end

	function PPM.CreateTexture(tname, data)
		local w, h=ScrW(), ScrH()
		local rttex=nil
		local size=data.size or 512
		rttex=GetRenderTarget(tname, size, size, false)

		if data.predrawfunc ~=nil then
			data.predrawfunc()
		end

		local OldRT=render.GetRenderTarget()
		render.SetRenderTarget(rttex)
		render.SuppressEngineLighting(true)
		cam.IgnoreZ(true)
		render.SetBlend(1)
		render.SetViewPort(0, 0, size, size)
		render.Clear(0, 0, 0, 255, true)
		cam.Start2D()
		render.SetColorModulation(1, 1, 1)

		if data.drawfunc ~=nil then
			data.drawfunc()
		end

		cam.End2D()
		render.SetRenderTarget(OldRT)
		render.SetViewPort(0, 0, w, h)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		render.SuppressEngineLighting(false)

		return rttex
	end

	function PPM.CreateBodyTexture(ent, pony)
		if not PPM.isValidPony(ent) then return end
		local w, h=ScrW(), ScrH()

		local function tW(val)
			return val
		end --val/512*w end

		local function tH(val)
			return val
		end --val/512*h end

		local rttex=nil
		ent.ponydata_tex=ent.ponydata_tex or {}

		if (ent.ponydata_tex.bodytex ~=nil) then
			rttex=ent.ponydata_tex.bodytex
		else
			rttex=GetRenderTarget(tostring(ent) .. "body", tW(512), tH(512), false)
		end

		local OldRT=render.GetRenderTarget()
		render.SetRenderTarget(rttex)
		render.SuppressEngineLighting(true)
		cam.IgnoreZ(true)
		render.SetLightingOrigin(Vector(0, 0, 0))
		render.ResetModelLighting(1, 1, 1)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		render.SetModelLighting(BOX_TOP, 1, 1, 1)
		render.SetViewPort(0, 0, tW(512), tH(512))
		render.Clear(0, 255, 255, 255, true)
		cam.Start2D()
		render.SetColorModulation(1, 1, 1)

		if (pony.gender==1) then
			render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodyf")))
		else
			render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodym")))
		end

		render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(pony.coatcolor.x * 255, pony.coatcolor.y * 255, pony.coatcolor.z * 255, 255), -90) --position of the rect

		--direction to face in
		--size of the rect
		--color
		--rotate 90 degrees
		if (pony.bodyt1 > 1) then
			render.SetMaterial(FixVertexLitMaterial(PPM.m_bodydetails[pony.bodyt1 - 1][1]))
			render.SetBlend(1)
			local colorbl=pony.bodyt1_color or Vector(1, 1, 1)
			render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(colorbl.x * 255, colorbl.y * 255, colorbl.z * 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
		end

		if (pony.bodyt0 > 1) then
			render.SetMaterial(FixVertexLitMaterial(PPM.m_bodyt0[pony.bodyt0 - 1][1]))
			render.SetBlend(1)
			render.DrawQuadEasy(Vector(tW(256), tH(256), 0), Vector(0, 0, -1), tW(512), tH(512), Color(255, 255, 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
		end

		cam.End2D()
		render.SetRenderTarget(OldRT) -- Resets the RenderTarget to our screen
		render.SetViewPort(0, 0, w, h)
		render.SetColorModulation(1, 1, 1)
		render.SetBlend(1)
		render.SuppressEngineLighting(false)
		--	cam.IgnoreZ(false)
		ent.ponydata_tex.bodytex=rttex
		--MsgN("HASHOLD: "..tostring(ent.ponydata_tex.bodytex_hash)) 
		ent.ponydata_tex.bodytex_hash=PPM.GetBodyHash(pony)
		--MsgN("HASHNEW: "..tostring(ent.ponydata_tex.bodytex_hash)) 
		--MsgN("HASHTAR: "..tostring(PPM.GetBodyHash(outpony))) 

		return rttex
	end

	PPM.VALIDPONY_CLASSES={"player", "prop_ragdoll", "prop_physics", "cpm_pony_npc"}

	function HOOK_HUDPaint()
		for name, ent in pairs(ents.GetAll()) do
			if (ent ~=nil and (table.HasValue(PPM.VALIDPONY_CLASSES, ent:GetClass()) or string.match(ent:GetClass(), "^(npc_)") ~=nil)) then
				if (PPM.isValidPonyLight(ent)) then
					local pony=PPM.getPonyValues(ent, false)

					if (not PPM.isValidPony(ent)) then
						PPM.setupPony(ent)
					end

					local texturespreframe=1

					for k, v in pairs(PPM.rendertargettasks) do
						if (PPM.TextureIsOutdated(ent, k, v.hash(pony))) then
							if texturespreframe > 0 then
								ent.ponydata_tex=ent.ponydata_tex or {}
								PPM.currt_ent=ent
								PPM.currt_ponydata=pony
								PPM.currt_success=false
								ent.ponydata_tex[k]=PPM.CreateTexture(tostring(ent) .. k, v)
								ent.ponydata_tex[k .. "_hash"]=v.hash(pony)
								ent.ponydata_tex[k .. "_draw"]=PPM.currt_success
								texturespreframe=texturespreframe - 1
							end
						end
					end
				end
				--MsgN("Outdated texture at "..tostring(ent)..tostring(ent:GetClass()))
			else
				if (ent.isEditorPony) then
					local pony=PPM.getPonyValues(ent, true)

					if (not PPM.isValidPony(ent)) then
						PPM.setupPony(ent)
					end

					for k, v in pairs(PPM.rendertargettasks) do
						if (PPM.TextureIsOutdated(ent, k, v.hash(pony))) then
							ent.ponydata_tex=ent.ponydata_tex or {}
							PPM.currt_ent=ent
							PPM.currt_ponydata=pony
							PPM.currt_success=false
							ent.ponydata_tex[k]=PPM.CreateTexture(tostring(ent) .. k, v)
							ent.ponydata_tex[k .. "_hash"]=v.hash(pony)
							ent.ponydata_tex[k .. "_draw"]=PPM.currt_success
						end
					end
				end
			end
		end
	end

	hook.Add("HUDPaint", "pony_render_textures", HOOK_HUDPaint)

	PPM.loadrt=function()
		PPM.currt_success=false
		PPM.currt_ent=nil
		PPM.currt_ponydata=nil
		PPM.rendertargettasks={}

		PPM.rendertargettasks["bodytex"]={
			renderTrue=function(ENT, PONY)
				PPM.m_body:SetVector("$color2", Vector(1, 1, 1))
				PPM.m_body:SetTexture("$basetexture", ENT.ponydata_tex.bodytex)
			end,
			renderFalse=function(ENT, PONY)
				PPM.m_body:SetVector("$color2", PONY.coatcolor)

				if (PONY.gender==1) then
					PPM.m_body:SetTexture("$basetexture", PPM.m_bodyf:GetTexture("$basetexture"))
				else
					PPM.m_body:SetTexture("$basetexture", PPM.m_bodym:GetTexture("$basetexture"))
				end
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata

				if (pony.gender==1) then
					render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodyf")))
				else
					render.SetMaterial(FixVertexLitMaterial(Material("models/ppm/base/render/bodym")))
				end

				render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(pony.coatcolor.x * 255, pony.coatcolor.y * 255, pony.coatcolor.z * 255, 255), -90) --position of the rect

				--direction to face in
				--size of the rect
				--color
				--rotate 90 degrees
				--MsgN("render.body.prep")
				for C=1, 8 do
					local detailvalue=pony["bodydetail" .. C] or 1
					local detailcolor=pony["bodydetail" .. C .. "_c"] or Vector(0, 0, 0)

					if (detailvalue > 1) and (PPM.m_bodydetails[detailvalue - 1]) then
						--MsgN("rendering tex id: ",detailvalue," col: ",detailcolor)
						render.SetMaterial(PPM.m_bodydetails[detailvalue - 1][1]) --Material("models/ppm/base/render/clothes_sbs_full")) 
						--surface.SetTexture(surface.GetTextureID("models/ppm/base/render/horn"))
						render.SetBlend(1)
						render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(detailcolor.x * 255, detailcolor.y * 255, detailcolor.z * 255, 255), -90) --position of the rect
						--direction to face in
						--size of the rect
						--color
						--rotate 90 degrees
					end
				end

				local pbt=pony.bodyt0 or 1

				if (pbt > 1) then
					local mmm=PPM.m_bodyt0[pbt - 1]

					if (mmm ~=nil) then
						render.SetMaterial(FixVertexLitMaterial(mmm)) --Material("models/ppm/base/render/clothes_sbs_full")) 
						--surface.SetTexture(surface.GetTextureID("models/ppm/base/render/horn"))
						render.SetBlend(1)
						render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(255, 255, 255, 255), -90) --position of the rect
						--direction to face in
						--size of the rect
						--color
						--rotate 90 degrees
					end
				end

				PPM.currt_success=true
			end,
			hash=function(ponydata)
				local hash=tostring(ponydata.bodyt0) .. tostring(ponydata.coatcolor) .. tostring(ponydata.gender)

				for C=1, 8 do
					local detailvalue=ponydata["bodydetail" .. C] or 1
					local detailcolor=ponydata["bodydetail" .. C .. "_c"] or Vector(0, 0, 0)
					hash=hash .. tostring(detailvalue) .. tostring(detailcolor)
				end

				return hash
			end
		}

		PPM.rendertargettasks["hairtex1"]={
			renderTrue=function(ENT, PONY)
				PPM.m_hair1:SetVector("$color2", Vector(1, 1, 1))
				--PPM.m_hair2:SetVector("$color2", Vector(1,1,1)) 
				PPM.m_hair1:SetTexture("$basetexture", ENT.ponydata_tex.hairtex1)
			end,
			renderFalse=function(ENT, PONY)
				PPM.m_hair1:SetVector("$color2", PONY.haircolor1)
				--PPM.m_hair2:SetVector("$color2", PONY.haircolor2) 
				PPM.m_hair1:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			end,
			--PPM.m_hair2:SetTexture("$basetexture",Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture")) 
			drawfunc=function()
				local pony=PPM.currt_ponydata
				render.Clear(pony.haircolor1.x * 255, pony.haircolor1.y * 255, pony.haircolor1.z * 255, 255, true)
				PPM.tex_drawhairfunc(pony, "up", false)
			end,
			hash=function(ponydata) return tostring(ponydata.haircolor1) .. tostring(ponydata.haircolor2) .. tostring(ponydata.haircolor3) .. tostring(ponydata.haircolor4) .. tostring(ponydata.haircolor5) .. tostring(ponydata.haircolor6) .. tostring(ponydata.mane) .. tostring(ponydata.manel) end
		}

		PPM.rendertargettasks["hairtex2"]={
			renderTrue=function(ENT, PONY)
				--PPM.m_hair1:SetVector("$color2", Vector(1,1,1))
				PPM.m_hair2:SetVector("$color2", Vector(1, 1, 1))
				PPM.m_hair2:SetTexture("$basetexture", ENT.ponydata_tex.hairtex2)
			end,
			renderFalse=function(ENT, PONY)
				--PPM.m_hair1:SetVector("$color2", PONY.haircolor1) 
				PPM.m_hair2:SetVector("$color2", PONY.haircolor2)
				--PPM.m_hair1:SetTexture("$basetexture",Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture")) 
				PPM.m_hair2:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata
				PPM.tex_drawhairfunc(pony, "dn", false)
			end,
			hash=function(ponydata) return tostring(ponydata.haircolor1) .. tostring(ponydata.haircolor2) .. tostring(ponydata.haircolor3) .. tostring(ponydata.haircolor4) .. tostring(ponydata.haircolor5) .. tostring(ponydata.haircolor6) .. tostring(ponydata.mane) .. tostring(ponydata.manel) end
		}

		PPM.rendertargettasks["tailtex"]={
			renderTrue=function(ENT, PONY)
				PPM.m_tail1:SetVector("$color2", Vector(1, 1, 1))
				PPM.m_tail2:SetVector("$color2", Vector(1, 1, 1))
				PPM.m_tail1:SetTexture("$basetexture", ENT.ponydata_tex.tailtex)
			end,
			renderFalse=function(ENT, PONY)
				PPM.m_tail1:SetVector("$color2", PONY.haircolor1)
				PPM.m_tail2:SetVector("$color2", PONY.haircolor2)
				PPM.m_tail1:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
				PPM.m_tail2:SetTexture("$basetexture", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata
				PPM.tex_drawhairfunc(pony, "up", true)
			end,
			hash=function(ponydata) return tostring(ponydata.haircolor1) .. tostring(ponydata.haircolor2) .. tostring(ponydata.haircolor3) .. tostring(ponydata.haircolor4) .. tostring(ponydata.haircolor5) .. tostring(ponydata.haircolor6) .. tostring(ponydata.tail) end
		}

		PPM.rendertargettasks["eyeltex"]={
			renderTrue=function(ENT, PONY)
				PPM.m_eyel:SetTexture("$Iris", ENT.ponydata_tex.eyeltex)
			end,
			renderFalse=function(ENT, PONY)
				PPM.m_eyel:SetTexture("$Iris", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata
				PPM.tex_draweyefunc(pony, false)
			end,
			hash=function(ponydata) return tostring(ponydata.eyecolor_bg) .. tostring(ponydata.eyecolor_iris) .. tostring(ponydata.eyecolor_grad) .. tostring(ponydata.eyecolor_line1) .. tostring(ponydata.eyecolor_line2) .. tostring(ponydata.eyecolor_hole) .. tostring(ponydata.eyeirissize) .. tostring(ponydata.eyeholesize) .. tostring(ponydata.eyejholerssize) .. tostring(ponydata.eyehaslines) end
		}

		PPM.rendertargettasks["eyertex"]={
			renderTrue=function(ENT, PONY)
				PPM.m_eyer:SetTexture("$Iris", ENT.ponydata_tex.eyertex)
			end,
			renderFalse=function(ENT, PONY)
				PPM.m_eyer:SetTexture("$Iris", Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture"))
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata
				PPM.tex_draweyefunc(pony, true)
			end,
			hash=function(ponydata) return tostring(ponydata.eyecolor_bg) .. tostring(ponydata.eyecolor_iris) .. tostring(ponydata.eyecolor_grad) .. tostring(ponydata.eyecolor_line1) .. tostring(ponydata.eyecolor_line2) .. tostring(ponydata.eyecolor_hole) .. tostring(ponydata.eyeirissize) .. tostring(ponydata.eyeholesize) .. tostring(ponydata.eyejholerssize) .. tostring(ponydata.eyehaslines) end
		}

		PPM.tex_drawhairfunc=function(pony, UPDN, TAIL)
			local hairnum=pony.mane

			if UPDN=="dn" then
				hairnum=pony.manel
			elseif TAIL then
				hairnum=pony.tail
			end

			PPM.hairrenderOp(UPDN, TAIL, hairnum)
			local colorcount=PPM.manerender[UPDN .. hairnum]

			if TAIL then
				colorcount=PPM.manerender["tl" .. hairnum]
			end

			if colorcount ~=nil then
				local coloroffcet=colorcount[1]

				if UPDN=="up" then
					coloroffcet=0
				end

				local prephrase=UPDN .. "mane_"

				if TAIL then
					prephrase="tail_"
				end

				colorcount=colorcount[2]
				local backcolor=pony["haircolor" .. (coloroffcet + 1)] or PPM.defaultHairColors[coloroffcet + 1]
				render.Clear(backcolor.x * 255, backcolor.y * 255, backcolor.z * 255, 255, true)

				for I=0, colorcount - 1 do
					local color=pony["haircolor" .. (I + 2 + coloroffcet)] or PPM.defaultHairColors[I + 2 + coloroffcet] or Vector(1, 1, 1)
					local material=Material("models/ppm/partrender/" .. prephrase .. hairnum .. "_mask" .. I .. ".png")
					render.SetMaterial(material)
					render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512, 512, Color(color.x * 255, color.y * 255, color.z * 255, 255), -90) --position of the rect
					--direction to face in
					--size of the rect
					--color
					--rotate 90 degrees
				end
			else
				if TAIL then end

				if UPDN=="dn" then
					render.Clear(pony.haircolor2.x * 255, pony.haircolor2.y * 255, pony.haircolor2.z * 255, 255, true)
				else
					render.Clear(pony.haircolor1.x * 255, pony.haircolor1.y * 255, pony.haircolor1.z * 255, 255, true)
				end
			end
		end

		PPM.tex_draweyefunc=function(pony, isR)
			local prefix="l"

			if (not isR) then
				prefix="r"
			end

			local backcolor=pony.eyecolor_bg or Vector(1, 1, 1)
			local color=1.3 * pony.eyecolor_iris or Vector(0.5, 0.5, 0.5)
			local colorg=1.3 * pony.eyecolor_grad or Vector(1, 0.5, 0.5)
			local colorl1=1.3 * pony.eyecolor_line1 or Vector(0.6, 0.6, 0.6)
			local colorl2=1.3 * pony.eyecolor_line2 or Vector(0.7, 0.7, 0.7)
			local holecol=1.3 * pony.eyecolor_hole or Vector(0, 0, 0)
			render.Clear(backcolor.x * 255, backcolor.y * 255, backcolor.z * 255, 255, true)
			local material=Material("models/ppm/partrender/eye_oval.png")
			render.SetMaterial(material)
			local drawlines=pony.eyehaslines==1 -- or true
			local holewidth=pony.eyejholerssize or 1
			local irissize=pony.eyeirissize or 0.6
			local holesize=(pony.eyeirissize or 0.6) * (pony.eyeholesize or 0.7)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(color.x * 255, color.y * 255, color.z * 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			--grad 
			local material=Material("models/ppm/partrender/eye_grad.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorg.x * 255, colorg.y * 255, colorg.z * 255, 255), -90) --position of the rect

			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			if drawlines then
				--eye_line_l1
				local material=Material("models/ppm/partrender/eye_line_" .. prefix .. "2.png")
				render.SetMaterial(material)
				render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorl2.x * 255, colorl2.y * 255, colorl2.z * 255, 255), -90) --position of the rect
				--direction to face in
				--size of the rect
				--color
				--rotate 90 degrees
				local material=Material("models/ppm/partrender/eye_line_" .. prefix .. "1.png")
				render.SetMaterial(material)
				render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(colorl1.x * 255, colorl1.y * 255, colorl1.z * 255, 255), -90) --position of the rect
				--direction to face in
				--size of the rect
				--color
				--rotate 90 degrees
			end

			--hole
			local material=Material("models/ppm/partrender/eye_oval.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * holesize * holewidth, 512 * holesize, Color(holecol.x * 255, holecol.y * 255, holecol.z * 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			local material=Material("models/ppm/partrender/eye_effect.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(255, 255, 255, 255), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			local material=Material("models/ppm/partrender/eye_reflection.png")
			render.SetMaterial(material)
			render.DrawQuadEasy(Vector(256, 256, 0), Vector(0, 0, -1), 512 * irissize, 512 * irissize, Color(255, 255, 255, 255 * 0.5), -90) --position of the rect
			--direction to face in
			--size of the rect
			--color
			--rotate 90 degrees
			PPM.currt_success=true
		end

		PPM.hairrenderOp=function(UPDN, TAIL, hairnum)
			if TAIL then
				if PPM.manerender["tl" .. hairnum] ~=nil then
					PPM.currt_success=true
				end
			else
				if PPM.manerender[UPDN .. hairnum] ~=nil then
					PPM.currt_success=true
				end
			end
		end

		--/PPM.currt_success=true
		--MsgN(UPDN,TAIL,hairnum,"=",PPM.currt_success)
		PPM.manerender={}
		PPM.manerender.up5={0, 1}
		PPM.manerender.up6={0, 1}
		PPM.manerender.up8={0, 2}
		PPM.manerender.up9={0, 3}
		PPM.manerender.up10={0, 1}
		PPM.manerender.up11={0, 3}
		PPM.manerender.up12={0, 1}
		PPM.manerender.up13={0, 1}
		PPM.manerender.up14={0, 1}
		PPM.manerender.up15={0, 1}
		PPM.manerender.dn5={0, 1}
		PPM.manerender.dn8={3, 2}
		PPM.manerender.dn9={3, 2}
		PPM.manerender.dn10={0, 3}
		PPM.manerender.dn11={0, 2}
		PPM.manerender.dn12={0, 1}
		PPM.manerender.tl5={0, 1}
		PPM.manerender.tl8={0, 5}
		PPM.manerender.tl10={0, 1}
		PPM.manerender.tl11={0, 3}
		PPM.manerender.tl12={0, 2}
		PPM.manerender.tl13={0, 1}
		PPM.manerender.tl14={0, 1}
		PPM.manecolorcounts={}
		PPM.manecolorcounts[1]=1
		PPM.manecolorcounts[2]=1
		PPM.manecolorcounts[3]=1
		PPM.manecolorcounts[4]=1
		PPM.manecolorcounts[5]=1
		PPM.manecolorcounts[6]=1
		PPM.defaultHairColors={Vector(252, 92, 82) / 256, Vector(254, 134, 60) / 256, Vector(254, 241, 160) / 256, Vector(98, 188, 80) / 256, Vector(38, 165, 245) / 256, Vector(124, 80, 160) / 256}

		PPM.rendertargettasks["ccmarktex"]={
			size=256,
			renderTrue=function(ENT, PONY)
				PPM.m_cmark:SetTexture("$basetexture", ENT.ponydata_tex.ccmarktex)
			end,
			renderFalse=function(ENT, PONY)
				--PPM.m_cmark:SetTexture("$basetexture",Material("models/ppm/partrender/clean.png"):GetTexture("$basetexture")) 
				if (PONY==nil) then return end
				if (PONY.cmark==nil) then return end
				if (PPM.m_cmarks[PONY.cmark]==nil) then return end
				if (PPM.m_cmarks[PONY.cmark][2]==nil) then return end
				if (PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture")==nil) then return end
				if (PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture")==NULL) then return end
				PPM.m_cmark:SetTexture("$basetexture", PPM.m_cmarks[PONY.cmark][2]:GetTexture("$basetexture"))
			end,
			drawfunc=function()
				local pony=PPM.currt_ponydata
				local data=pony._cmark[1]

				if pony.custom_mark and data then
					render.SetColorMaterialIgnoreZ()
					render.SetBlend(1)
					PPM.BinaryImageToRT(data)
					PPM.currt_success=true
				else
					render.Clear(0, 0, 0, 0)
					PPM.currt_success=false
				end
			end,
			hash=function(ponydata) return tostring(ponydata._cmark[1] ~=nil) .. (ponydata.custom_mark or "") end
		}
	end
end