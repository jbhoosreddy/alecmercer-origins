try destroyDialog (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO") catch()


rollout alignPivotLocatorRO "Align / Pivot / Locator"
(
	struct rotPosStruct
	(
		rotation = (quat 1),
		position = [0,0,0]
	)
		--// Mode Selection
	groupBox gbMode " Mode " pos:[4,5] width:80 height:98
	checkbutton btnAlign "Align" pos:[10,24] width:68 height:20 checked:true
	checkbutton btnPivot "Pivot" pos:[10,50] width:68 height:20
	checkbutton btnLocator "Locator" pos:[10,76] width:68 height:20
	
	
		--// Align Mode
	groupBox gbReferenceNode " Reference Node " pos:[94,5] width:172 height:47 --// width:491
	dropDownList ddReferenceNode "" pos:[100,25] width:160 height:21
	
	groupBox gbOperation " Operation" pos:[94,56] width:172 height:47
	dropDownList ddOperation "" pos:[100,75] width:160 height:21
	label labOperationTo "Direction:" pos:[200,63] visible:false
	dropDownList ddOperationTo "" pos:[187,75] width:72 height:21 visible:false
	spinner spnDistance "" pos:[187,78] width:72 height:21 range:[-1000,1000,0] visible:false
	spinner spnDirection "" pos:[187,78] width:72 height:21 range:[-360,360,180] visible:false
	
	groupBox gbTiming " Timing " pos:[272,5] width:142 height:98
	label labSetRange "Set Range:" pos:[281,30] width:56 height:18
	button btnSelection "Selection" pos:[347,20] width:60 height:16
	button btnAll "All" pos:[347,36] width:60 height:16
	
	button btnStart "Start" pos:[280,58] width:42 height:20
	spinner spnStart "" pos:[278,80] width:44 height:16 range:[0,9999,0] type:#integer fieldWidth:35 scale:1
	
	button btnEnd "End" pos:[328,58] width:42 height:20
	spinner spnEnd "" pos:[326,80] width:44 height:16 range:[0,9999,0] type:#integer fieldWidth:35 scale:1
	
	label labSteps "By:" pos:[378,61] width:15 height:18
	spinner spnSteps "" pos:[354,80] width:54 height:16 range:[0,50,1] type:#integer fieldWidth:25 scale:1
	
	groupBox gbProcess " Process " pos:[421,5] width:81 height:98
	button btnApply "Apply" pos:[428,24] width:68 height:20
	button btnStartEnd "Start / End" pos:[428,50] width:68 height:20
	button btnRange "Range" pos:[428,76] width:68 height:20
	
	groupBox gbUsedAxis " Used Axis " pos:[509,5] width:147 height:98 visible:false  --// width:644
	label labX "X" pos:[548,21] width:12 height:14 visible:false
	label labY "Y" pos:[572,21] width:12 height:14 visible:false
	label labZ "Z" pos:[596,21] width:12 height:14 visible:false
	label labOffset "Offset" pos:[618,21] width:30 height:14 visible:false
	label labPos "Pos" pos:[517,35] width:22 height:14 visible:false
	label labRot "Rot" pos:[517,52] width:22 height:14 visible:false
	checkbox chkPosX "" pos:[546,34] width:18 height:16 visible:false checked:true
	checkbox chkPosY "" pos:[570,34] width:18 height:16 visible:false checked:true
	checkbox chkPosZ "" pos:[594,34] width:18 height:16 visible:false checked:true
	checkbox chkPosOffset "" pos:[617,34] width:18 height:16 visible:false
	checkbox chkRotX "" pos:[546,51] width:18 height:16 visible:false checked:true
	checkbox chkRotY "" pos:[570,51] width:18 height:16 visible:false checked:true
	checkbox chkRotZ "" pos:[594,51] width:18 height:16 visible:false checked:true
	checkbox chkRotOffset "" pos:[617,51] width:18 height:16 visible:false
	button btnOffset "S" pos:[636,35] width:14 height:31 visible:false
	
	label labEditOffset1 "Pos" pos:[516,70] visible:false
	label labEditOffset2 "Rot" pos:[516,85] visible:false
	edittext edOffset1 "" pos:[541,67] fieldWidth:104 visible:false
	edittext edOffset2 "" pos:[541,82] fieldWidth:104 visible:false
	
	
		--// Pivot Mode
	groupBox gbPivot " Pivot " pos:[94,5] width:167 height:98 visible:false
	button btnSelectPivot "Select Pivot" pos:[113,22] width:128 height:20 visible:false
	
	groupBox gbPivotPoint " Pivot Point " pos:[99,45] width:76 height:54 visible:false
	button btnCreatePivotPoint "Create" pos:[110,62] width:52 height:16 visible:false
	button btnDeletePivotPoint "Delete" pos:[110,78] width:52 height:16 visible:false
	
	groupBox gbSnapshot " Snapshot " pos:[180,45] width:76 height:54 visible:false
	button btnSingle "Single" pos:[191,62] width:52 height:16 visible:false
	button btnChildren "+Children" pos:[191,78] width:52 height:16 visible:false
	
	
		--// Locator Mode
	groupBox gbLocator " Locator " pos:[94,5] width:117 height:98 visible:false
	button btnCreateLocator "Create" pos:[103,24] width:48 height:20 visible:false
	button btnDeleteLocator "Delete" pos:[157,24] width:48 height:20 visible:false
	button btnReset "Reset" pos:[103,54] width:48 height:20 visible:false
	button btnAuto "Auto" pos:[157,54] width:48 height:20 visible:false
	button btnMoveToBodyMass "Move to Body Mass" pos:[103,76] width:102 height:20 visible:false
	
	
	
	
	
	
	function updateDDSelection op:undefined =
	(
		local tempArray = #()
		local tempArrayNames = #()
							
		for obj in objects do
		(
			if obj.isHidden == false then					
				append tempArray obj.name
		)
		
		sort tempArray
		
		if tempArray.count != 0 then
			insertItem "----------------------------------------" tempArray 1

		insertItem "--------- Update List -----------" tempArray 1
		insertItem "----- Current Selection ------" tempArray 1
			
		if ddReferenceNode.items.count != tempArray.count then
			ddReferenceNode.items = tempArray
	)
	
	
	
	
	
	function updateDDOperation output:unsupplied =
	(
		local ddOperationItems = #( "Planted Key", "Sliding Key", "Free Key", "--------------------------------------------", "Move","Move/Rotate","--------------------------------------------", "Move to Floor","Reset Rotation","Rotate Anim","--------------------------------------------", "Copy" , "Paste", "--------------------------------------------","Bip to [0,0]","Bip to [0,0,0]", "--------------------------------------------", "Make World Prop Key")
		local ddOperationToItems = #( "Snapshot", "Pivot Point" )
		
		case output of
		(
			#ddOp:
				return ddOperationItems
			#ddOpTo:
				return ddOperationToItems
		)
		
		local ddSelIndex = #(5,6,13)
		local spnSelIndex = #(8,10)
		
		ddOperationTo.visible = false
		labOperationTo.text = ""
		labOperationTo.visible = false
		ddOperation.items = ddOperationItems
		ddOperation.width = 160
		spnDistance.visible = false
		spnDirection.visible = false
		btnApply.enabled = true
		btnStartEnd.enabled = true
		spnSteps.enabled = true
		
		
		
		
		if ddReferenceNode.selection < 2 then
		(
			case ddOperation.selection of
			(
				5: (labOperationTo.text = "Reference :" ; ddOperationTo.items = #( "Snapshot", "Pivot Point" ) )
				6: (labOperationTo.text = "Reference :" ; ddOperationTo.items = #( "Snapshot", "Pivot Point" ) )
				8: (labOperationTo.text = "Floor Distance :" ; spnDistance.visible = true )
				10: (labOperationTo.text = "Direction :" ; spnDirection.visible = true ; spnSteps.enabled = false ; btnStartEnd.enabled = false )
				13: (labOperationTo.text = "Controller :" ; ddOperationTo.items = #( "Transform", "Position", "Rotation" ) )
			)
			
			if (findItem ddSelIndex ddOperation.selection) != 0 then
			(
				labOperationTo.visible = true
				ddOperationTo.visible = true
				ddOperation.width = 86
			)
			
			if (findItem spnSelIndex ddOperation.selection) != 0 then
			(
				labOperationTo.visible = true
				ddOperation.width = 86
			)
			
			
				
			if ddOperation.selection == 8 then
			(	
				local tempVar = cryMaxTools.anim.functions.op.moveToFloor getHeight:true
				if tempVar != undefined then
					if (queryBox "Get Height from Selection?" title:"Move to Floor") == true then
						spnDistance.value = tempVar
			)
			
		)
		else
		(
			ddOperation.items = #( "Align", "Line" )
			if ddOperation.selection == 0 then ddOperation.selection = 1
			
			if ddOperation.selection == 2 then
			(
				btnApply.enabled = false
				updateDDSelection op:false
			)
			else
			(
				btnApply.enabled = true
				updateDDSelection op:true
			)
		)
	)
	
	
	
	
	
	function updateMode mode =
	(
		local alignArray = #(gbReferenceNode, ddReferenceNode, gbOperation,	ddOperation, \
									ddOperationTo, labOperationTo, spnDistance, spnDirection, \
									spnStart, btnEnd, spnEnd, gbProcess, btnApply, btnStartEnd, btnRange)
									
		local axisArray = #(gbUsedAxis, labX, labY, labZ, labOffset, labPos, labRot, chkPosX, chkPosY, \
									chkPosZ, chkPosOffset, chkRotX, chkRotY, chkRotZ, chkRotOffset, btnOffset, labEditOffset1, labEditOffset2, edOffset1, edOffset2)
			
		local pivotArray = #(gbPivot, btnSelectPivot, gbPivotPoint, btnCreatePivotPoint, btnDeletePivotPoint, gbSnapshot, btnSingle, btnChildren)
		
		local locatorArray = #(gbLocator, btnCreateLocator, btnDeleteLocator, btnReset, btnAuto, btnMoveToBodyMass)

		local showArray = #()
		local hideArray = #()

		case mode of
		(
			#align:
			(
				showArray = alignArray
				join hideArray pivotArray
				join hideArray locatorArray
				
				if ddReferenceNode.selection > 1 then
				(
					join showArray axisArray
					alignPivotLocatorRO.width = 660
				)
				else
				(
					join hideArray axisArray
					alignPivotLocatorRO.width = 506
				)
			)
			
			#pivot:
			(
				showArray = pivotArray
				join hideArray alignArray
				join hideArray locatorArray
				join hideArray axisArray
				
				alignPivotLocatorRO.width = 266
			)
			
			#locator:
			(
				showArray = locatorArray
				join hideArray alignArray
				join hideArray pivotArray
				join hideArray axisArray
				
				alignPivotLocatorRO.width = 216
			)
			
			#none:
			(
				join hideArray alignArray
				join hideArray pivotArray
				join hideArray locatorArray
				join hideArray axisArray
				
				alignPivotLocatorRO.width = 89
			)
			
			#axis:
			(
				showArray = axisArray
				
				alignPivotLocatorRO.width = 660
			)
		)
		
		for i = 1 to showArray.count do
			showArray[i].visible = true
		
		for i = 1 to hideArray.count do
			hideArray[i].visible = false
		
		if mode == #align then
			updateDDOperation()
	)
	
	
	
	
	
	function updateOffset =
	(
		local tempArray = #([0,0,0], (eulerangles 0 0 0))
		
		try
		(
			if cryMaxTools.basic.vars.various[35].count > 0 then
			(
				if chkPosOffset.checked == true then
					tempArray[1] = cryMaxTools.basic.vars.various[35][1].position as String
				if chkRotOffset.checked == true then
					tempArray[2] = cryMaxTools.basic.vars.various[35][1].rotation as eulerangles
				
				tempArray[2] = (tempArray[2].x as Integer) as String + " " + (tempArray[2].y as Integer) as String + " " + (tempArray[2].z as Integer) as String
			)
		)catch()
		
		edOffset1.text = tempArray[1]
		edOffset1.text = tempArray[2]
	)
	
	
	
	




	function alignSelection tempSel tempNode =
	(	
		local posAxis = #(false, false, false, false)
		local rotAxis = #(false, false, false, false)
		
		if chkPosX.checked == true then	posAxis[1] = true
		if chkPosY.checked == true then	posAxis[2] = true
		if chkPosZ.checked == true then	posAxis[3] = true
		if chkPosOffset.checked == true then	posAxis[4] = true
		
		if chkRotX.checked == true then	rotAxis[1] = true
		if chkRotY.checked == true then	rotAxis[2] = true
		if chkRotZ.checked == true then	rotAxis[3] = true
		if chkRotOffset.checked == true then	rotAxis[4] = true
		
		
		

		for i = 1 to tempSel.count do
		(
			local tempPos = tempSel[i].transform.pos
			local tempRot = tempSel[i].transform.rotation as eulerangles
			
			local offsetTM = matrix3 1
			
			if rotAxis[4] == true or posAxis[4] == true then
				offsetTM = cryMaxTools.anim.vars.various[35][i] * tempNode.transform

			
			if rotAxis[4] == false then
			(
				if rotAxis[1] == true then tempRot.x = (tempNode.transform.rotation as eulerangles).x
				if rotAxis[2] == true then tempRot.y = (tempNode.transform.rotation as eulerangles).y
				if rotAxis[3] == true then tempRot.z = (tempNode.transform.rotation as eulerangles).z
			)
			else
			(
				if rotAxis[1] == true then tempRot.x = (offsetTM.rotation as eulerangles).x
				if rotAxis[2] == true then tempRot.y = (offsetTM.rotation as eulerangles).y
				if rotAxis[3] == true then tempRot.z = (offsetTM.rotation as eulerangles).z
			)
			
			
			
			
			
			if posAxis[4] == false then
			(
				if posAxis[1] == true then tempPos[1] = tempNode.transform.pos[1]
				if posAxis[2] == true then tempPos[2] = tempNode.transform.pos[2]
				if posAxis[3] == true then tempPos[3] = tempNode.transform.pos[3]
			)						
			else
			(
				if posAxis[1] == true then tempPos[1] = offsetTM.pos[1]
				if posAxis[2] == true then tempPos[2] = offsetTM.pos[2]
				if posAxis[3] == true then tempPos[3] = offsetTM.pos[3]
			)
			
			
			local tempMatrix = tempSel[i].transform
			tempMatrix.rotation = tempRot
			tempMatrix.pos = tempPos
			
			
			if tempSel[i].classID[1] == 37157 then
			(
				biped.setTransform tempSel[i] #pos tempMatrix.pos true
				biped.setTransform tempSel[i] #rotation tempMatrix.rotation true
			)
			else
			(
				try
					tempSel[i].transform = tempMatrix
				catch
					print "Error aligning Node!"
			)
		)
	)

	
	
	
	
	
	function alignSelectionLine startPos endPos axis tempSel tempNode =
	(
		local diffAll = endPos[axis] - startPos[axis]
		local diffSel = tempNode.transform.pos[axis] - startPos[axis]
		
		local tempPos = 0
		try ( tempPos = biped.getTransform tempNode #pos )
		catch ( tempPos = tempNode.pos )
			
			
			
		local time = diffSel / diffAll
			
		local newPos = (endPos * time) + (startPos * (1 - time))
			
		try
			biped.setTransform tempSel #pos newPos true
		catch
			tempSel.pos = newPos
	)
	
	
	
	
	

	
	
	
	
	
	function applyOperation operation opTo start end steps =
	(	
		--if ddReferenceNode.selection != 1 then
			--snapshots = cryMaxTools.anim.functions.op.createSnapshot()

		
		axis = 0
		local startPos = [0,0,0]
		local endPos = [0,0,0]
		
		
		if (ddReferenceNode.selection > 2)	and (ddOperation.selection == 2) then
		(
			tempNode = $
			
			sliderTime = animationRange.start
			startPos = tempNode.transform.pos
			sliderTime = animationRange.end
			endPos = tempNode.transform.pos
			tempStart = 0
			
			if startPos == endPos then
			(
				messageBox ("Start point is equal to End Point") title:"Line Operation"
				return false
			)
				
				
			
			
			
			for i = 1 to 3 do
			(
				local tempStartPos = startPos[i]
				local tempEndPos = endPos[i]
				
				if tempStartPos < 0 then tempStartPos -= tempStartPos * 2
				if tempEndPos < 0 then tempEndPos -= tempEndPos * 2
				
				
				
				local tempPos =  tempEndPos - tempStartPos
				if tempPos > tempStart then
				(
					axis = i
					tempStart = tempPos
				)
			)
		)
		
		
		
		local tempTMArray = #()
		
		if operation < 4 then
		(
			for obj in selection do
			(
				local tempKeyArray = #()
				
				for i = start to end do
					at time i
						append tempKeyArray obj.transform
					
				append tempTMArray tempKeyArray
			)
		)
		
		
		
		
		
		
		if operation == 10 then
		(
			local animDir = spnDirection.value
			local undoString = "rotate " +  animDir as String
			if start == end then
				undo undoString on ( cryMaxTools.anim.functions.op.rotateAnim animDir )
			else
			(
				undo undoString on ( cryMaxTools.anim.functions.op.rotateAnim animDir range:true )
				return false
			)
		)
		
		saveSliderTime = sliderTime
		sliderTime = start
		
		if selection.count == 1 then
			disableSceneRedraw()
			
		
		
		
		

		local tempIndex = 1
		
		if operation == 12 then
		(
			deleteFile cryMaxTools.basic.vars.tempFilePath
			cryMaxTools.anim.vars.transformList = #()
			for f = 1 to $selection.count do
				append cryMaxTools.anim.vars.transformList (#())
		)


		if selection.count == 0 then
		(
			print "Nothing selected."
			return false
		)
		
		
		
		
		
		for i = start to end by steps do
		(
			escapeEnable = true
			
			sliderTime = i
			case operation of
			(
				1:
				(
					if ddReferenceNode.selection == 1 then
					(
						undo "make planted key" on
						(
							local objIndex = 1
							
							for obj in selection do
							(
								tempArray = obj.controller.keys
								keyIndex = 0
								for i = 1 to tempArray.count do
									if tempArray[i].time == sliderTime then keyIndex = i
								try
								(	
									tempKey = biped.getKey obj.controller keyIndex
									if tempKey.ikSpace != 1 or tempKey.ikJoinedPivot == false or tempKey.ikBlend != 1.0 then
										biped.setPlantedKey obj
									
									biped.setTransform obj #pos tempTMArray[objIndex][tempIndex].pos true
									biped.setTransform obj #rotation tempTMArray[objIndex][tempIndex].rotation true
								)
								catch
								(
									try ( biped.setPlantedKey obj ) catch ( )
								)
								
								objIndex += 1
							)
						)
					)
					else
					(
						undo "align biped object" on
							alignSelection (getCurrentSelection()) (getNodeByName ddReferenceNode.selected) --snapshots:snapshots
					)
				)
				2:
				(
					if ddReferenceNode.selection == 1 then
					(
						undo "make sliding key" on
						(
							local objIndex = 1
							
							for obj in selection do
							(
								local tempArray = obj.controller.keys
								local keyIndex = 0
								for i = 1 to tempArray.count do
									if tempArray[i].time == sliderTime then keyIndex = i

								biped.setTransform obj #pos tempTMArray[objIndex][tempIndex].pos true
								biped.setTransform obj #rotation tempTMArray[objIndex][tempIndex].rotation true
									
								try
								(
									local tempKey = biped.getKey obj.controller keyIndex
									if tempKey.ikSpace != 1 or tempKey.ikJoinedPivot == true or tempKey.ikBlend != 1.0 then 
										biped.setSlidingKey obj
									
									
								)
								catch
								(
									try ( biped.setSlidingKey obj ) catch ( )
								)
								
								objIndex += 1
							)
						)
					)
					else
					(
						undo "lineOperation" on
						(
							for obj in selection do
								if obj.isHidden == false then												
									alignSelectionLine startPos endPos axis obj (getNodeByName ddReferenceNode.selected)
						)
					)
				)
				3:
				(
					undo "make free key" on
					(
						local objIndex = 1
						
						for obj in selection do
						(
							tempArray = obj.controller.keys
							keyIndex = 0
							for i = 1 to tempArray.count do
								if tempArray[i].time == sliderTime then keyIndex = i
								
							try
							(
								tempKey = biped.getKey obj.controller keyIndex
								if tempKey.ikSpace != 0 or tempKey.ikJoinedPivot == false or tempKey.ikBlend != 0.0 then 
									biped.setFreeKey obj
								
								biped.setTransform obj #pos tempTMArray[objIndex][tempIndex].pos true
								biped.setTransform obj #rotation tempTMArray[objIndex][tempIndex].rotation true
							)
							catch
							(
								try	( biped.setFreeKey obj ) catch ( )
							)
							
							objIndex += 1
						)
					)
				)				
			
				5:
				(
					case ddOperationTo.selection of
					(
						1:( undo "move to snapshot" on ( cryMaxTools.anim.align.functions.moveBipPart() ) )
						2:( undo "move to pivot point" on ( cryMaxTools.anim.align.functions.moveBipPart pivotPoint:true ) )
					)
				)
				6:
				(
					case ddOperationTo.selection of
					(
						1:( undo "move/rotate to snapshot" on ( cryMaxTools.anim.align.functions.moveRotBipPart() ) )	
						2:( undo "move/rotate to pivot point" on ( cryMaxTools.anim.align.functions.moveRotBipPart pivotPoint:true ) )	
					)
				)
				
				8:( undo "move to floor" on ( cryMaxTools.anim.functions.op.moveToFloor value:spnDistance.value) )
				9:( undo "reset rotation" on ( cryMaxTools.anim.functions.op.resetRotation() ) )
				
				12:
				(
					try deleteFile cryMaxTools.anim.vars.tempINIPath catch()
					
					local tempSel = getCurrentSelection()
					
					for d = 1 to tempSel.count do
					(
						setINISetting cryMaxTools.anim.vars.tempINIPath ("Object" + d as String) "Name" tempSel[d].name
						setINISetting cryMaxTools.anim.vars.tempINIPath ("Object" + d as String) (tempIndex as String) (tempSel[d].transform as String)
					)
				)
				13:
				(
					undo "paste transform" on
					(
						for d = 1 to 5000 do
						(
							local tempNode = getNodeByName (getINISetting cryMaxTools.anim.vars.tempINIPath ("Object" + d as String) "Name")
							if tempNode != undefined then
							(
								local newTran = getINISetting cryMaxTools.anim.vars.tempINIPath ("Object" + d as String) (tempIndex as String)
								if newTran != "" then
								(
									newTran = execute ( newTran )
									
									case ddOperationTo.selection of
									(	
										1:( cryMaxTools.anim.functions.op.pasteTransform tempNode newTran #transform )
										2:( cryMaxTools.anim.functions.op.pasteTransform tempNode newTran #pos )
										3:( cryMaxTools.anim.functions.op.pasteTransform tempNode newTran #rotation	)
									)
								)
							)
						)
					)
				)

				
				15:( undo "bip to [0,0]" on ( cryMaxTools.anim.functions.op.bipToZero2() ) )
				16:( undo "bip to [0,0,0]" on ( cryMaxTools.anim.functions.op.bipToZero3() ) )
				18:
				(
					undo "propWorldKey" on
					(
						for obj in selection do
						(
							if obj.classID[1] == 37157 then
							(
								local propKey = undefined
								
								try
								(
									for d = 1 to obj.controller.keys.count do
									(
										local tempKey = biped.getKey obj.controller d
										if tempKey.time == sliderTime then
										(
											propKey = tempKey
											exit
										)
									)
								)
								catch()
								
								if propKey != undefined then
								(
									try
									(
										setProperty propKey #posSpace 0
										setProperty propKey #rotSpace 0
									)
									catch()
								)
							)
							
						)
					)
				)
			)
			
			tempIndex += 1
			
		)
		if isSceneRedrawDisabled() == true then
			enableSceneRedraw()
		
		--if snapshots != undefined then
			--for obj in snapshots do
				--delete obj
			
		sliderTime = saveSliderTime
		
		if operation >= 11 and operation <= 13 then
			return false
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	on alignPivotLocatorRO open do
	(
		updateDDSelection()
		
		ddOperation.items = updateDDOperation output:#ddOp
		ddOperationTo.items = updateDDOperation output:#ddOpTo
		
		safePos = cryMaxTools.basic.settingsMan.load "alignPivotLocatorRO" intoRollout:true returnPos:true
		
		try 
			if classOf safePos[1].value[1] == Point2 then
				safePos = safePos[1].value[1]
			else
				safePos = [300,200]
		catch
			safePos = [300,200]
		
		
		if (cryMaxTools.basic.ROMan.get "loadSaveRO") != undefined then
		(
			if (cryMaxTools.basic.ROMan.get "loadSaveRO").open == true then
				if (cryMaxTools.basic.ROMan.get "loadSaveRO").btnAlignLocator.checked == true then
					 safePos = [((getDialogPos (cryMaxTools.basic.ROMan.get "loadSaveRO"))[1]), ((getDialogPos (cryMaxTools.basic.ROMan.get "loadSaveRO"))[2] + 219)]
		)
		
		setDialogPos (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO") safePos
		
		
		if getDialogPos (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO") == [-800,0] then
			setDialogPos (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO") [300,200]
		
		
		
		
		
	)
	
	
	on alignPivotLocatorRO close do
	(
		cryMaxTools.basic.settingsMan.save (#("alignPivotLocatorRO", (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO")))
		
		try
		(
			if cryMaxTools.anim.loadSave.alignLocatorChange == undefined then
				try (cryMaxTools.basic.ROMan.get "loadSaveRO").btnAlignLocator.checked = false catch()
		)catch()
	)
	
	
	on btnAlign changed value do
	(
		if value == true then
		(
			btnPivot.checked = false
			btnLocator.checked = false
			updateMode #align
		)
		if btnAlign.checked == btnPivot.checked and btnAlign.checked == btnLocator.checked then
			updateMode #none
	)
	
	on btnPivot changed value do
	(
		if value == true then
		(
			btnAlign.checked = false
			btnLocator.checked = false
			updateMode #pivot
		)
		if btnAlign.checked == btnPivot.checked and btnAlign.checked == btnLocator.checked then
			updateMode #none
	)
	
	on btnLocator changed value do
	(
		if value == true then
		(
			btnAlign.checked = false
			btnPivot.checked = false
			updateMode #locator
		)
		if btnAlign.checked == btnPivot.checked and btnAlign.checked == btnLocator.checked then
			updateMode #none
	)
	
	
	
	
	on btnSelectPivot pressed do
	(
		if (local selectedBipPart = cryMaxTools.anim.functions.op.getSelectedBipPart() ) != undefined then
		(
			if selectedBipPart.object.isPivot == true then
			(
				undo off
					cryMaxTools.anim.align.functions.callPivotSelect()
			)
			else
				print "Pivot Selection not available for this Object"
		)
		else
		(
			if selection.count > 0 then
				print "No Biped Object selected."
			else
				print "Nothing selected."
		)
	)
	
	
	on btnCreatePivotPoint pressed do
	(
		if (selectedBipPart = cryMaxTools.anim.functions.op.getSelectedBipPart() ) != undefined then
		(
			if selectedBipPart.pivotSel.index == undefined then
				messageBox "Select a Pivot first" title:"Pivot Point" beep:false
			else							
				if (cryMaxTools.anim.align.functions.pivotPoint #check) == true then
				(
					if (queryBox "Set new Pivot Point?" title:"Pivot Point" beep:false) == true then
						if (cryMaxTools.anim.align.functions.pivotPoint #delete) == true then
							cryMaxTools.anim.align.functions.pivotPoint #create
				)
				else
					cryMaxTools.anim.align.functions.pivotPoint #create							
		)
		else
		(
			if selection.count > 0 then
				print "No Biped Object selected."
			else
				print "Nothing selected"
		)
	)
	
	
	
	on btnDeletePivotPoint pressed do
	(
			if (selectedBipPart = cryMaxTools.anim.functions.op.getSelectedBipPart() ) != undefined then						
				if selectedBipPart.pivotSel.pivPoint.name != undefined then
					if (queryBox "Delete Pivot Point?" title:"Pivot Point" beep:false) == true then
						cryMaxTools.anim.align.functions.pivotPoint #delete
	)
	
	
	
	on btnSingle pressed do
	(
		with animate off
		(
			if cryMaxTools.anim.functions.op.createSnapshot() == undefined then
				print "Nothing selected"
		)
	)
	
	
	
	
	on btnChildren pressed do
	(
		with animate off
		(
			local baseArray = cryMaxTools.anim.functions.op.createSnapshot children:true
			
			if baseArray == undefined then
				print "Nothing selected"
			else
				group baseArray prefix:"Snapshot_"
		)
	)
	
	
	
	
	
	
	on btnCreateLocator pressed do
	(
		if $Bip01 != undefined then
		(
			if queryBox "Create Locator_Locomotion?" title:"Locator_Locomotion" == true then
			(
				undo "create Locator_Locomotion" on
				(
					try
					(
						with redraw off
						(
							local locVertArray = #([-2.60474,5.627,0], [-2.60474,5.627,5.306], [-2.60501,-5.627,5.306], [-2.60501,-5.627,2.40557e-006], [2.60475,5.627,0], [2.60475,5.627,5.306], [2.60499,-5.627,5.306], [2.605,-5.627,1.88326e-007], [-5.71044,-5.62699,5.306], [-5.71044,-5.62699,3.72612e-006], [5.71043,-5.62701,-1.24204e-006], [5.71043,-5.62701,5.306], [-9.4768e-006,-11.63,-1.24204e-006], [-9.48043e-006,-11.63,5.306])
							$Bip01.controller.figureMode = true
							$Bip01.controller.prop1Exists = false
							
							tempSaveRot = $Bip01.transform.rotation
							tempBipRot = $Bip01.transform.rotation as eulerangles
							if tempBipRot.z > 0 and tempBipRot.z < 180 then
								tempBipRot.z = -90
							
							biped.setTransform $Bip01 #rotation tempBipRot false
							
							$Bip01.controller.prop1Exists = true
							
							tempSel = biped.getNode $Bip01 20
							tempSel.name = "Locator_Locomotion"
							select tempSel
							tempTM = tempSel.transform
							tempTM.rotation = (quat 0 0 -1 0)
							tempTM.pos = [0,0,0]
							biped.setTransform tempSel #rotation tempTM.rotation false
							biped.setTransform tempSel #pos tempTM.pos false
						
							
							tempPanel = getCommandPanelTaskMode()
							setCommandPanelTaskMode #modify
							
							
							addModifier tempSel (Edit_Poly())
							
							
							
							
							tempBit = #{1..(polyOp.getNumVerts tempSel)}
							tempSel.modifiers[1].setSelection 1 tempBit
							tempSel.modifiers[1].setOperation #DeleteVertex
							tempSel.modifiers[1].commit()


							for i = 1 to locVertArray.count do
							(
								tempSel.modifiers[1].CreateVertex [0,0,0]
							)
							tempSel.modifiers[1].commit()
							tempSel.modifiers[1].SetEPolySelLevel #Vertex

							for i = 1 to locVertArray.count do
							(
								tempSel.modifiers[1].SetSelection #Vertex #{}
								tempSel.modifiers[1].Select #Vertex #{i}
								tempSel.modifiers[1].Commit()
								tempSel.modifiers[1].moveSelection locVertArray[i]
								tempSel.modifiers[1].Commit()
								
							)

							tempSel.modifiers[1].CreateFace #(6,5,1)
							tempSel.modifiers[1].CreateFace #(6,1,2)
							tempSel.modifiers[1].CreateFace #(7,6,2)
							tempSel.modifiers[1].CreateFace #(2,3,7)
							tempSel.modifiers[1].CreateFace #(8,5,6)
							tempSel.modifiers[1].CreateFace #(6,7,8)
							tempSel.modifiers[1].CreateFace #(1,4,3)
							tempSel.modifiers[1].CreateFace #(3,2,1)
							tempSel.modifiers[1].CreateFace #(1, 4,5)
							tempSel.modifiers[1].CreateFace #(4,5, 8)
							tempSel.modifiers[1].CreateFace #(11,8,7)
							tempSel.modifiers[1].CreateFace #(7,12,11)
							tempSel.modifiers[1].CreateFace #(3,4, 10)
							tempSel.modifiers[1].CreateFace #(3, 9,10)
							tempSel.modifiers[1].CreateFace #(9,14,12)
							tempSel.modifiers[1].CreateFace #(11,12,14)
							tempSel.modifiers[1].CreateFace #(14,13,11)
							tempSel.modifiers[1].CreateFace #(10,13,14)
							tempSel.modifiers[1].CreateFace #(10,14,9)
							tempSel.modifiers[1].CreateFace #(10,13,11)

							tempSel.modifiers[1].SetSelection #Vertex #{}
							tempSel.modifiers[1].SetEPolySelLevel #Object
							
							
							
							

							tempSel.modifiers[1].Commit()
							
							tempSel.wireColor = (color 255 0 0)
							
							biped.setTransform $Bip01 #rotation tempSaveRot true
							
							$Bip01.controller.figureMode = false
							
							setCommandPanelTaskMode tempPanel
							
							cryMaxTools.anim.functions.op.resetLocator()
						)
						
						redrawviews()
					)catch (print "Error Creating Locator_Locomotion")
				)
			)
		)
		else
			messageBox "No Biped in Scene." title:"Error Creating Locator_Locomotion"
	)
	
	
	on btnDeleteLocator pressed do
	(
		if $Bip01 != undefined then
		(
			if queryBox "Delete Locator_Locomotion?" title:"Locator_Locomotion" == true then
			(
				undo "delete Locator_Locomotion" on
				(
					try
					(
						$Bip01.controller.figureMode = true
						$Bip01.controller.prop1Exists = false 
						$Bip01.controller.figureMode = false
					) catch ( print "Error Deleting Locatot_Locomtion" )
				)
			)
		)
		else
			messageBox "No Biped in Scene." title:"Error Deleting Locator_Locomotion"
	)
	
	

	on btnReset pressed do
	(
		if $Locator_Locomotion != undefined then
			undo "Reset Locator" on
				cryMaxTools.anim.functions.op.resetLocator()
		else print "No Locator in Scene."
	)
	
	
	on btnAuto pressed do
	(
		if $Locator_Locomotion != undefined then
			undo "Auto Locator" on
				try (	cryMaxTools.anim.functions.op.autoLocator() ) catch( print "Can't execute: Auto Locator")
		else print "No Locator in Scene."
	)
	
	on btnMoveToBodyMass pressed do
	(
		if $Locator_Locomotion != undefined then
			undo "Move to BodyMass" on
				try (	cryMaxTools.anim.functions.op.moveToBodyMass() ) catch( print "Can't execute: Move to Body Mass")
		else print "No Locator in Scene."
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	on ddReferenceNode selected value do
	(
		if ddReferenceNode.selection <= 3 then
		(
			updateDDSelection op:false
			ddReferenceNode.selection = 1
			updateMode #align
	
		)
		else
		(
			updateDDSelection op:true
			updateMode #axis
		)
		
		updateDDOperation()
	)
	
	
	
	

	on btnOffset pressed do
	(
		if $selection.count > 0 then
		(	
			cryMaxTools.anim.vars.various[35] = #()
			
			--local tempSnap = cryMaxTools.anim.functions.op.createSnapshot()
			for obj in selection do
			(
				append cryMaxTools.anim.vars.various[35] (obj.transform * inverse (getNodeByName ddReferenceNode.selected).transform)--(rotPosStruct rotation:obj.rotation position:obj.pos)
			)
			--for obj in tempSnap do
				--delete obj
			
			local tempArray = #([0,0,0], (eulerangles 0 0 0))
		
			try
			(
				if cryMaxTools.anim.vars.various[35].count > 0 then
				(
					--if chkPosOffset.checked == true then
						tempArray[1] = cryMaxTools.anim.vars.various[35][1].pos as String
					--if chkRotOffset.checked == true then
						tempArray[2] = cryMaxTools.anim.vars.various[35][1].rotation as eulerangles
					
					tempArray[2] = (tempArray[2].x as Integer) as String + " " + (tempArray[2].y as Integer) as String + " " + (tempArray[2].z as Integer) as String
				)
			)catch()
			
			try
			(
				edOffset1.text = tempArray[1]
				edOffset2.text = tempArray[2]
			)catch()
			
			
			
			
		)
		else
			messageBox "No Node selected." title:"Set Offset"
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	on btnStart pressed do
	(
		spnStart.value = sliderTime
	)
	
	on btnEnd pressed do
	(
		spnEnd.value = sliderTime
	)


	
	on spnSteps changed value do
	(
		local diffStartEnd = spnEnd.value - spnStart.value
		if diffStartEnd < 0 then
			diffStartEnd -= (diffStartEnd * 2)
			
		if value > diffStartEnd then
			spnSteps.value = diffStartEnd
		if spnSteps.value == 0 then spnSteps.value = 1
	)
	
	
	on btnSelection pressed do
	(
		if selection.count > 0 then
		(
			local firstKey = 0
			local lastKey = 0
			for obj in selection do
			(
				if obj.classID[1] == 37157 then
				(
					try
					(
						local tempFirstKey = obj.transform.controller.keys[1].time.frame
						if tempFirstKey < firstKey then
							firstKey = tempFirstKey
					)catch()
					
					try
					(
						local tempLastkey = obj.transform.controller.keys[obj.transform.controller.keys.count].time.frame
						if tempLastKey > lastKey then
							lastKey = tempLastKey
					)catch()
					
				)
				else
				(
					
					for i = 1 to 3 do
					(
						try
						(
							
							local tempFirstKey = obj.controller[i].keys[1].time.frame
							if tempFirstKey < firstKey then
								firstKey = tempFirstKey
						)
						catch()
						
						
						try
						(
							local tempLastkey = obj.controller[i].keys[obj.controller[i].keys.count].time.frame
							if tempLastKey > lastKey then
								lastKey = tempLastKey
						)
						catch()
					)
				)
			)
			
			if firstKey != lastKey then
				animationRange = interval firstKey lastKey
			else
				animationRange = interval firstKey (lastKey + 1)
		)
		else
			print "Nothing selected."
		
	)
	
	
	
	on btnAll pressed do
	(
		local firstKey = 0
		local lastKey = 0
		for obj in Objects do
		(
			if obj.classID[1] == 37157 then
			(
				try
				(
					local tempFirstKey = obj.transform.controller.keys[1].time.frame
					if tempFirstKey < firstKey then
						firstKey = tempFirstKey
				)catch()
				
				try
				(
					local tempLastkey = obj.transform.controller.keys[obj.transform.controller.keys.count].time.frame
					if tempLastKey > lastKey then
						lastKey = tempLastKey
				)catch()
				
			)
			else
			(
				
				for i = 1 to 3 do
				(
					try
					(
						
						local tempFirstKey = obj.controller[i].keys[1].time.frame
						if tempFirstKey < firstKey then
							firstKey = tempFirstKey
					)
					catch()
					
					
					try
					(
						local tempLastkey = obj.controller[i].keys[obj.controller[i].keys.count].time.frame
						if tempLastKey > lastKey then
							lastKey = tempLastKey
					)
					catch()
				)
			)
		)
		
		
		
		if firstKey != lastKey then
			animationRange = interval firstKey lastKey
		else
			animationRange = interval firstkey (lastKey + 1)
	)
	
	
	
	on ddOperation selected value do
	(
		case value of
		(
			4: ddOperation.selection -= 1
			7: ddOperation.selection -= 1
			11: ddOperation.selection -= 1
		)
		updateDDOperation()
	)
	
	
					
		
	on btnApply pressed do
	(
		setCommandPanelTaskMode #modify
		
		applyOperation ddOperation.selection ddOperationTo.selection sliderTime.frame sliderTime.frame 1	
	)
	
	on btnStartEnd pressed do
	(
		setCommandPanelTaskMode #modify
		
		if spnStart.value == spnEnd.value then
		(
			messageBox ("'Start' must be unequal to 'End'") title:"Begin/End Operation"
			return false
		)
		
		if spnStart.value > spnEnd.value then
		(
			tempValue = spnStart.value
			spnStart.value = spnEnd.value
			spnEnd.value = tempValue
		)
		
		local diffBeginEnd = spnEnd.value - spnStart.value
		if diffBeginEnd < 0 then
			diffBeginEnd -= (diffBeginEnd * 2)
		
		if spnSteps.value > diffBeginEnd then
			spnSteps.value = diffBeginEnd
		
		undo "BeginEndOperation" on
		(
			local tempAnimationRange = animationRange
			animationRange = interval spnStart.value spnEnd.value
			
			local tempBool = applyOperation ddOperation.selection ddOperationTo.selection spnStart.value spnEnd.value spnSteps.value
			if tempBool != false then
				applyOperation ddOperation.selection ddOperationTo.selection spnEnd.value spnEnd.value 1								

			animationRange = tempAnimationRange
		)
	)
	
	
	on btnRange pressed do
	(
		setCommandPanelTaskMode #modify
		
		undo "RangeOperation" on
		(
			tempBool = applyOperation ddOperation.selection ddOperationTo.selection animationRange.start.frame animationRange.end.frame spnSteps.value
			if tempBool != false then
				applyOperation ddOperation.selection ddOperationTo.selection animationRange.end.frame animationRange.end.frame 1
		)
	)
	
)

cryMaxTools.basic.ROMan.cryAdd "alignPivotLocatorRO" alignPivotLocatorRO #main



createDialog (cryMaxTools.basic.ROMan.get "alignPivotLocatorRO") 506 108 -800 0