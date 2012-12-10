try destroyDialog aimPoses catch()

rollout aimPoses "Aim Pose  Creator"
(
	
	struct poseStruct
	(
		yaw = 0.0,
		pitch = 0.0
	)
	
	struct aimIKPoseStruct
	(
		poses = #(),
		weights = #()
	)
	
	struct baseAnimStruct
	(
		node,
		TM = matrix3 1
	)
	
	struct IKTargetPoseStruct
	(
		target = matrix3 1,
		weight = 0.0
	)
	
	
	struct IKTargetNodeStruct
	(
		targetNode = "",
		blendNode = "",
		effectorNode = "",
		poses = #()
	)
	
	
	
	
	
	struct nodeStruct
	(
		node = "",
		defaultTM = (matrix3 1),
		offsetTM = (matrix3 1),
		rotOffset = (quat 1),
		parent,
		delta,
		tempKeys = #(),
		baseAnim = #(),
		localBaseAnim = #(),
		aimIKPoses = #(),
		influence = 0.0,
		align,
		poses = #()
	)
	
	
	
	struct nodePresetStruct
	(
		name = "",
		usedPoses = 1,
		nodes = #()
	)
	
	
	struct posePresetStruct
	(
		name,
		poses = #()
	)
	
	
	struct aimJointStruct
	(
		name = "",
		root = "",
		poses = #(),
		IKTargets = #()
	)
	
	
	
	local nodePresets = #()
	local posePresets = #()
	
	local nodeArray = #()
	
	local safeNodeArray = #()
	local alignNodeTo = undefined
	local alignNodeDefaultTM = (matrix3 1)
	local alignNodeOffsetTM = (matrix3 1)
	
	local previewUsedCount = 0
	
	local filePath = ""
	local aimPosePath = ""
	
	local blendWeight1 = 0.0
	local blendWeight2 = 0.0
	
	local aimDir = quat 1
	local aimJoint = aimJointStruct()
	
	local aimIK = #()
	local aimIKRoot = #()
	local saveAnimRange = interval 0 1
	
	
	
	groupbox gbUseSelection "" pos:[5,10] height:315 width:540
	checkbox chkUseSelection "Use Selection" pos:[15,10]
	
	button btnSettings "[...]" pos:[15,31] height:20 width:20
	
	button btnNodeSettings "<- Nodes" pos:[165,31] height:20 width:60
	dropdownlist ddNodePreset "" pos:[40,30] height:10 width:120
	
	button btnPoseSettings "<- Poses" pos:[360,31] height:20 width:60
	dropdownlist ddPosePreset "" pos:[235,30] height:10 width:120
	
	label labPoseCount "Pose Count :" pos:[430,33]
	spinner spnPoseCount "" pos:[495,32] height:10 width:40 range:[0,60,0] type:#integer
	
	dotNetControl lvNodes "System.Windows.Forms.DataGridView" pos:[15,60] height:200 width:520
	
	button btnAddNode "+" pos:[15,268] height:14 width:14
	button btnSetNode "Set Node" pos:[29,265] height:20 width:60
	button btnRemoveNode "-" pos:[89,268] height:14 width:14
	
	button btnRemoveAlign "-" pos:[195+100,268] height:14 width:14
	button btnSetAlign "Set Align" pos:[135+100,265] height:20 width:60
	
	
	spinner spnInfluence "Influence " pos:[245-127,267] fieldWidth:40 range:[-100.0,100.0,100.0]
	spinner spnYaw "Yaw " pos:[373,267] fieldWidth:40 range:[-180,180,0]
	spinner spnPitch "Pitch " pos:[456,267] fieldWidth:40 range:[-180,180,0]
	
	
	
	label labUpdateOffset "Update\n Offset" pos:[15,292] height:30 width:50
	button btnRemoveOffsetSel "-" pos:[60,298] height:14 width:14
	button btnUpdateSel "Sel" pos:[74,295] height:20 width:25
	button btnUpdateAll "All" pos:[99,295] height:20 width:25
	button btnRemoveOffsetAll "-" pos:[124,298] height:14 width:14
	
	edittext edPosOffset "Pos:" pos:[150,297] width:190
	edittext edRotOffset "Rot:" pos:[345,297] width:190
	
	
	
	groupbox gbPoses " Poses " pos:[555,10] height:250 width:240
	
	button btnPose01 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose02 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose03 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose04 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose05 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose06 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose07 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose08 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose09 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose10 "0" pos:[570,25] height:18 width:18 visible:false
	
	button btnPose11 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose12 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose13 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose14 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose15 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose16 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose17 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose18 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose19 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose20 "0" pos:[570,25] height:18 width:18 visible:false
	
	button btnPose21 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose22 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose23 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose24 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose25 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose26 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose27 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose28 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose29 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose30 "0" pos:[570,25] height:18 width:18 visible:false
	
	button btnPose31 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose32 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose33 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose34 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose35 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose36 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose37 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose38 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose39 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose40 "0" pos:[570,25] height:18 width:18 visible:false
	
	button btnPose41 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose42 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose43 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose44 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose45 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose46 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose47 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose48 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose49 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose50 "0" pos:[570,25] height:18 width:18 visible:false
	
	button btnPose51 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose52 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose53 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose54 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose55 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose56 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose57 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose58 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose59 "0" pos:[570,25] height:18 width:18 visible:false
	button btnPose60 "0" pos:[570,25] height:18 width:18 visible:false
	
	
	
	
	checkbox chkUseAnimation "Use Animation" pos:[560,240]
	button btnCreatePoses "Create Poses" pos:[725,240] height:20 width:70
	
	
	groupbox gbAimIKSettings " AimIK " pos:[555,265] height:60 width:121
		--// DEACTIVATED
	button btnAlignToCamera "-->   Camera" pos:[560,280] height:18 width:110 visible:false
	button btnAlignFromCamera "<--   Camera" pos:[560,302] height:18 width:110 visible:false
		--// /DEACTIVATED
	
	
	checkbutton btnAimIKSettings "Settings" pos:[560+3,280] height:18 width:105
	checkbutton btnAimIKActive "Active" pos:[560+3,302] height:18 width:105 enabled:false
	
	groupbox gbAlignTools " Align Tools " pos:[555+120,265] height:60 width:120
	checkbox chkUseAlign "Use Align in List" pos:[690,280] width:100 checked:true
	button btnSelectionToAlign "Align" pos:[680+3,302] height:18 width:50
	button btnSelectionToAlignZero "Zero" pos:[680+3+55,302] height:18 width:50

	
	

	
	groupbox gbAimIK " AimIK Settings " pos:[5,330] height:43 width:790
	button btnImportAimPoses "|>" pos:[15,345] height:20 width:20 enabled:true
	button btnAimIKUpdate "Update" pos:[40,345] height:20 width:60 enabled:false
	button btnPickRootNode "Root Node" pos:[15+30+75,345] height:20 width:200
	button btnPickAimJoint "Aim Node" pos:[15+210+30+75,345] height:20 width:200
	
	
	groupbox gbAimIKBones "" pos:[225+87+240,330] height:43 width:(196-87)
	checkbox chkUseInfluences "Use Influences" pos:[240+85+240,338] height:18
	checkbox chkUseIKTargets "" pos:[240+85+240,354] height:18 width:18
	button btnSetIKTargets "Set IK Targets" pos:[240+85+240+18,354] height:16 width:75
	checkbox chkLayerAimIK "Layer AimIK" pos:[430+240,338] height:18 checked:true
	checkbox chkLayerAnim "Layer Existing Anim" pos:[430+240,354] height:18
	
	
	
	
	
	
	
	
	
	function updatePreview =
	(
		if nodeArray.count > 0 then
		(
			local maxPoses = previewUsedCount
			local index = 1
			
			
			if previewUsedCount < nodeArray[index].poses.count then
				maxPoses = nodeArray[index].poses.count
			
			for i = 1 to maxPoses do
			(
				local poseBtn = execute ("aimPoses.btnPose" + (if i > 9 then "" else "0") + i as String)
				local newPos = [666,130]
				
				if nodeArray[index].poses[i] != undefined then
				(
					local newTM = matrix3 1
					
					in coordsys world rotate newTM (eulerangles nodeArray[index].poses[i].pitch 0 0)
					in coordsys world rotate newTM (eulerangles 0 0 nodeArray[index].poses[i].yaw)
					
					newPos += -[((newTM.row2*100).x),((newTM.row2*100).z)]
					
					poseBtn.visible = true
					
					previewUsedCount = i
				)
				else
					poseBtn.visible = false
				
				poseBtn.pos = newPos
				poseBtn.text = (i-1) as String
			)
		)
		else
		(
			for i = 1 to 60 do
			(
				local poseBtn = execute ("aimPoses.btnPose" + (if i > 9 then "" else "0") + i as String)
				poseBtn.visible = false
			)
			
		)
	)
	

	
	
	
	
	
	function getValues =
	(
		spnYaw.value = 0.0
		spnPitch.value = 0.0
		
		edPosOffset.text = [0,0,0] as String
		edRotOffset.text = (quat 1) as String
		
		try
		(
			if nodeArray.count > 0 and lvNodes.selectedCells.count > 0 then
			(	
				local rowIndex = (lvNodes.selectedCells.item (lvNodes.selectedCells.count - 1)).rowIndex
				local columnIndex = (lvNodes.selectedCells.item (lvNodes.selectedCells.count - 1)).ColumnIndex
				
				spnInfluence.value = nodeArray[rowIndex+1].influence
				
				local poseIndex = 1
				
				if columnIndex > 2 then
					poseIndex = columnIndex - 2
				
				if nodeArray[1].poses.count > 0 then
				(
					spnYaw.value = nodeArray[rowIndex+1].poses[poseIndex].yaw
					spnPitch.value = nodeArray[rowIndex+1].poses[poseIndex].pitch
				)
				
				edPosOffset.text = nodeArray[rowIndex+1].posOffset.pos as String
				edRotOffset.text = nodeArray[rowIndex+1].rotOffset as String
			)
		)catch()
		
	)
	
	
	
	function setValue con =
	(
		if nodeArray.count > 0 then
		(
			for i = 0 to (lvNodes.selectedCells.count - 1) do
			(
				local selCell = lvNodes.selectedCells.item i
				local rowIndex = selCell.rowIndex
				if rowIndex > (nodeArray.count - 1) then
					exit
				
				local columnIndex = 3
				
				
				
				if selCell.columnIndex > 3 then
					columnIndex = selCell.columnIndex
				
				case con of
				(
					#influence:
					(
						((lvNodes.Rows.item rowIndex).cells.item 1).value = spnInfluence.value as String
						nodeArray[rowIndex+1].influence = spnInfluence.value
						
						local newBackStyle = dotNetObject "System.Windows.Forms.DataGridViewCellStyle"
						
						if spnInfluence.value >= 0.0 then
						(
							local counterValue = 255.0 - (150.0 * spnInfluence.value) / 100
							newBackStyle.backColor = newBackStyle.backColor.FromArgb 255 counterValue counterValue
						)
						else
						(
							local counterValue = 255.0 + (150.0 * spnInfluence.value) / 100
							newBackStyle.backColor = newBackStyle.backColor.FromArgb counterValue counterValue 255 
						)
						
						((lvNodes.Rows.item rowIndex).cells.item 0).style = newBackStyle
						
					)
					
					#yaw:
					(
						((lvNodes.Rows.item rowIndex).cells.item columnIndex).value = ("Y  " + spnYaw.value as String + "     P  " + nodeArray[rowIndex+1].poses[columnIndex-2].pitch as String)
						nodeArray[rowIndex + 1].poses[columnIndex-2].yaw = spnYaw.value
						
						if ddPosePreset.selection != 2 then
							ddPosePreset.selection = 2
						
						updatePreview()
					)
					
					#pitch:
					(
						((lvNodes.Rows.item rowIndex).cells.item columnIndex).value = ("Y  " + nodeArray[rowIndex+1].poses[columnIndex-2].yaw as String + "     P  " + spnPitch.value as String)
						nodeArray[rowIndex+1].poses[columnIndex-2].pitch = spnPitch.value
						
						if ddPosePreset.selection != 2 then
							ddPosePreset.selection = 2
						
						updatePreview()
					)
				)
			)
		)
	)
	

	
	
	function updateOffsets range:undefined =
	(
		local updateArray = #()
		
		if range == undefined then
		(
			for i = 0 to (lvNodes.selectedCells.count - 1) do
			(
				if (findItem updateArray (lvNodes.selectedCells.item i).rowIndex) == 0 then
					append updateArray ((lvNodes.selectedCells.item i).rowIndex + 1)
			)
		)
		else
		(
			for i = 1 to nodeArray.count do
				append updateArray i
		)
		
		
		
		for i = 1 to updateArray.count do
		(
			try
			(
				if chkUseSelection.checked == true then
					local updateNode = (selection as Array)[1]
				else
					local updateNode = getNodeByName nodeArray[updateArray[i]].node
				
				if updateNode != undefined then
				(
					nodeArray[updateArray[i]].rotOffset = (matrix3 1).rotation * inverse updateNode.transform.rotation
					nodeArray[updateArray[i]].defaultTM = updateNode.transform--(matrix3 1) * inverse updateNode.transform
					
					if chkUseSelection.checked == true then
						alignNodeDefaultTM = updateNode.transform
					
					if nodeArray[updateArray[i]].align != undefined then
					(
						local alignNode = getNodeByName nodeArray[updateArray[i]].align
						
						if alignNode != undefined then
							nodeArray[updateArray[i]].offsetTM = updateNode.transform * inverse alignNode.transform
						
						if chkUseSelection.checked == true then
							alignNodeOffsetTM = updateNode.transform * inverse alignNode.transform
					)
				)
			)catch()
		)
		
		getValues()
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function updateList =
	(
		local enableControls = true
		local enableBySelection = true
		local enableByPoses = false
		local enableByAlign = false
		
		if nodeArray.count > 0 then
		(
			lvNodes.RowCount = nodeArray.count + 1
			lvNodes.ColumnCount = nodeArray[1].poses.count + 3
			
			
			
			for i = 0 to (lvNodes.Columns.count - 1) do
			(
				(lvNodes.Columns.item i).SortMode = (lvNodes.Columns.item i).SortMode.NotSortable
				
				if i > 2 then
					(lvNodes.Columns.item i).name = "Pose " + (i-2) as String
			)
			
			
			for i = 1 to nodeArray.count do
			(
				((lvNodes.Rows.item (i-1)).Cells.item 0).value = nodeArray[i].node
				((lvNodes.Rows.item (i-1)).Cells.item 1).value = nodeArray[i].influence as String
				((lvNodes.Rows.item (i-1)).Cells.item 2).value = nodeArray[i].align

				local newBackStyle = dotNetObject "System.Windows.Forms.DataGridViewCellStyle"
				
				if nodeArray[i].influence >= 0 then
				(
					local counterValue = 255.0 - (150.0 * nodeArray[i].influence) / 100
					newBackStyle.backColor = newBackStyle.backColor.FromArgb 255 counterValue counterValue
				)
				else
				(
					local counterValue = 255.0 + (150.0 * nodeArray[i].influence) / 100
					newBackStyle.backColor = newBackStyle.backColor.FromArgb counterValue counterValue 255
				)
				
				
				((lvNodes.Rows.item (i-1)).cells.item 0).style = newBackStyle
				
				
				if nodeArray[i].align != undefined then
					enableByAlign = true
				
				
				for f = 1 to nodeArray[i].poses.count do
				(	
					if mod f 2.0 != 0.0 then
					(
						local newStyle = dotNetObject "System.Windows.Forms.DataGridViewCellStyle"
						newStyle.backColor = newStyle.backColor.FromArgb 245 245 245
						((lvNodes.Rows.item (i-1)).cells.item (f + 2)).style = newStyle
					)
					
					((lvNodes.Rows.item (i-1)).Cells.item (f + 2)).value = ("Y  " + nodeArray[i].poses[f].yaw as String + "     P  " + nodeArray[i].poses[f].pitch as String)
				)
			)
			
			(lvNodes.Rows.item (lvNodes.Rows.count - 1))
			
			if nodeArray[1].poses.count > 0 then
				enableByPoses = true
		)
		else
		(
			enableControls = false
			enableBySelection = false
			enableByPoses = false
			enableByAlign = false
			
			
			
			spnPoseCount.value = 0
			spnInfluence.value = 0.0
			spnYaw.value = 0.0
			spnPitch.value = 0.0
			
			lvNodes.ColumnCount = 3
			lvNodes.RowCount = 1
			
			((lvNodes.Rows.item 0).cells.item 0).value = undefined
			((lvNodes.Rows.item 0).cells.item 1).value = undefined
			((lvNodes.Rows.item 0).cells.item 2).value = undefined
			
			try
			(
				local resetStyle = dotNetObject "System.Windows.Forms.DataGridViewCellStyle"
				((lvNodes.Rows.item 0).cells.item 0).style = resetStyle
			)catch()
		)
		
		if chkUseSelection.checked == true then
		(
			enableBySelection = false
		)
		
		
		ddPosePreset.enabled = enableControls
		btnPoseSettings.enabled = enableControls
		spnPoseCount.enabled = enableControls
		spnInfluence.enabled = enableControls
		spnYaw.enabled = enableByPoses
		spnPitch.enabled = enableByPoses
		
		btnSetNode.enabled = enableBySelection
		btnRemoveNode.enabled = enableBySelection
		
		btnSetAlign.enabled = enableControls
		btnRemoveAlign.enabled = enableControls
		
		btnRemoveOffsetSel.enabled = enableBySelection
		btnUpdateSel.enabled = enableBySelection
		btnUpdateAll.enabled = enableControls
		btnRemoveOffsetAll.enabled = enableControls
		edPosOffset.enabled = enableByAlign
		edRotOffset.enabled = enableByAlign
		
		btnCreatePoses.enabled = enableByPoses
		chkUseAlign.enabled = enableBySelection
		btnSelectionToAlign.enabled = enableByAlign and not enableBySelection
		btnSelectionToAlignZero.enabled = not enableBySelection
		
		
		
		
		if enableByPoses == true or enableControls == true then
		(
			aimPoses.width = 800
			
			if btnAimIKSettings.checked == true then
				aimPoses.height = 378
		)
		else
		(
			aimPoses.width = 550
			aimPoses.height = 330
		)
		
		
		getValues()
		updatePreview()
	)
	
	
	
	
	
	
	function updatePoseByPreset =
	(	
		
		if ddPosePreset.selection != 2 then
		(
			for i = 1 to nodeArray.count do
			(
				if ddPosePreset.selection != 1 then
					nodeArray[i].poses = deepCopy posePresets[ddPosePreset.selection - 2].poses
				else
					nodeArray[i].poses = #()
			)
			
			if nodeArray.count > 0 then
				spnPoseCount.value = nodeArray[1].poses.count
		)
		
		if ddNodePreset.selection != 2 or ddPosePreset.selection != 2 then
			updateList()
	)
	
	
	
	
	
	function updateNodeByPreset useSel:false clearList:undefined =
	(
		if useSel == false then
		(
			if safeNodeArray != undefined then
			(
				nodeArray = deepCopy safeNodeArray 
				safeNodeArray = undefined
			)
			else
			(
				local presetSel = ddNodePreset.selection
				
				if clearList == true and presetSel != 2 then
					local presetSel = 1
				
				if presetSel > 2 then
				(
					nodeArray = nodePresets[ddNodePreset.selection - 2].nodes
					
					ddPosePreset.selection = nodePresets[ddNodePreset.selection - 2].usedPoses
				)
				else
				(
					if presetSel == 1 then
					(
						nodeArray = #()
						ddPosePreset.selection = 1
					)
				)
			)
		)
		else
		(
			safeNodeArray = deepCopy nodeArray
			local poses = #()
			if nodeArray.count > 0 then
				poses = deepCopy nodeArray[1].poses
			
			nodeArray = #((nodeStruct node:"-- Selection --" influence:100.0 align:alignNodeTo defaultTM:alignNodeDefaultTM offsetTM:alignNodeOffsetTM poses:poses))
			
			if nodeArray.count > 0 then
				spnPoseCount.value = nodeArray[1].poses.count
		)
		
		((lvNodes.rows.item 0).cells.item 0).selected = true
		
		if presetSel != 2 then
			updatePoseByPreset()
	)
	
	
	
	
	
	function updatePreset dir =
	(
		local newArray = #("  --- Empty ---", " --- Custom ---")
		local oldArray = #()
		
		case dir of
		(
			#nodes: oldArray = nodePresets
			#poses: oldArray = posePresets
		)
		
		for i = 1 to oldArray.count do
			append newArray oldArray[i].name
		
		case dir of
		(
			#nodes:	ddNodePreset.items = newArray
			#poses:	ddPosePreset.items = newArray
		)
	)
	
	
	
	
	
	function saveSettings saveAs:undefined =
	(
		if filePath == "" or saveAs == true then
			local newPath = getSaveFileName caption:"Save Aim Pose Template" filename:filePath
		else
			local newPath = filePath
		
		
		if newPath != undefined then
		(
			local xmlFile = dotNetObject "system.xml.xmlDocument"
			local fileRoot = xmlFile.createElement "AimPoses"
			xmlFile.appendChild fileRoot
			
			
				
			local nodeRoot =  xmlFile.createElement "NodePresets"
			
			for i = 1 to nodePresets.count do
			(
				local preset = xmlFile.createElement ("Preset")
				preset.setAttribute "Name" nodePresets[i].name
				preset.setAttribute "UsedPoses" (nodePresets[i].usedPoses as String)
				
				for f = 1 to nodePresets[i].nodes.count do
				(
					local presetNode = xmlFile.createElement "Node"
					presetNode.setAttribute "Name" nodePresets[i].nodes[f].node
					presetNode.setAttribute "Influence" (nodePresets[i].nodes[f].influence as String)
					
					if nodePresets[i].nodes[f].align != undefined then
						presetNode.setAttribute "Align" nodePresets[i].nodes[f].align
					
					preset.appendChild presetNode
				)
				
				nodeRoot.appendChild preset
			)
			
			fileRoot.appendChild nodeRoot
			
		

			local poseRoot =  xmlFile.createElement "PosePresets"
			
			for i = 1 to posePresets.count do
			(
				local preset = xmlFile.createElement ("Preset")
				preset.setAttribute "Name" posePresets[i].name
				
				for f = 1 to posePresets[i].poses.count do
				(
					local presetPose = xmlFile.createElement ("Pose" + f as String)
					presetPose.setAttribute "Yaw" (posePresets[i].poses[f].yaw as String)
					presetPose.setAttribute "Pitch" (posePresets[i].poses[f].pitch as String)
					
					preset.appendChild presetPose
				)
				
				poseRoot.appendChild preset
			)
			
			fileRoot.appendChild poseRoot
			
			try (deleteFile newPath) catch()
			
			cryMaxTools.basic.perforceMan.open newPath
			
			xmlFile.save newPath
			
			filePath = newPath
		)
	)
	
	
	
	
	
	function loadSettings load:undefined =
	(
		if load == undefined then
			local newPath = getOpenFileName caption:"Open Aim Pose Template" filename:filePath
		else
		(
			if (getFiles filePath).count == 0 then
				local newPath = getOpenFileName caption:"Open Aim Pose Template" filename:filePath
			else
				local newPath = filePath
		)
		
		if newPath != undefined then
		(
			local xmlFile = dotNetObject "system.xml.xmlDocument"
			
			xmlFile.load newPath
			
			local fileRoot = xmlFile.documentElement
			
			local preset = fileRoot.childNodes.itemOf[0]
			
			local presetNodes = #()
			local presetPoses = #()
			
			for i = 0 to (preset.childNodes.count - 1) do
			(
				local presetNodeArray = #()
				
				local presetEntry = preset.childNodes.itemOf[i]
				local presetName = presetEntry.attributes.itemOf[0].value
				local presetUsedPoses = presetEntry.attributes.itemOf[1].value as Integer
				
				
				for f = 0 to (presetEntry.childNodes.count - 1) do
				(
					local nodeName = presetEntry.childNodes.itemOf[f].attributes.itemOf[0].value
					local influence = 100.0
					local align = undefined
					
					try influence = (presetEntry.childNodes.itemOf[f].attributes.itemOf[1].value as float) catch()
					try align = presetEntry.childNodes.itemOf[f].attributes.itemOf[2].value catch()
					
					append presetNodeArray (nodeStruct node:nodeName influence:influence align:align)
				)
				
				append presetNodes (nodePresetStruct name:presetName usedPoses:presetUsedPoses nodes:presetNodeArray)
			)
			
			
			
			
			
			preset = fileRoot.childNodes.itemOf[1]
			
			for i = 0 to (preset.childNodes.count - 1) do
			(
				local presetPoseArray = #()
				
				local presetEntry = preset.childNodes.itemOf[i]
				local presetName = presetEntry.attributes.itemOf[0].value
				
				for f = 0 to (presetEntry.childNodes.count - 1) do
					append presetPoseArray (poseStruct yaw:(presetEntry.childNodes.itemOf[f].attributes.itemOf[0].value as float) pitch:(presetEntry.childNodes.itemOf[f].attributes.itemOf[1].value as float) )
				
				append presetPoses (posePresetStruct name:presetName poses:presetPoseArray)
			)
			
			
			
			nodePresets = presetNodes
			posePresets = presetPoses
			
			updatePreset #nodes
			updatePreset #poses
			
			if nodePresets.count > 0 then
			(
				ddNodePreset.selection = 3
				updateNodeByPreset()
			)
			filePath = newPath
		)
	)
	
	
	
	
	
	
	--////////////////////////////
	--// AIMIK
	--////////////////////////////
	
	
	function updateAimDir =
	(
		if $AimIKDir != undefined then
		(
			aimDir = $AimIKDir.transform.rotation
			--edAimDir.text = aimDir as String
		)
	)
	
	
	
	
	function createAimDirNode =
	(
		if $AimIKDir == undefined then
		(
			local aimNode = point pos:[0,0,200] name:"AimIKDir" wireColor:red
			
			deleteAllChangeHandlers id:#aimIKNodeChange
			
			when transform aimNode change id:#aimIKNodeChange handleAt:#redrawViews do
			(
				try aimPoses.updateAimDir() catch()
			)
		)
		
		updateAimDir()
	)
	
	
	
	function getLocalRot obj =
	(
		if obj.parent != undefined then
			return (obj.transform * inverse obj.parent.transform)
		else
			return obj.transform
	)
	
	
	
	
	
	
	
	
	function saveAimPoseFile filepath =
	(
		local xmlFile = dotNetObject "system.xml.xmlDocument"
		local fileRoot = xmlFile.createElement "AimPoses"
		xmlFile.appendChild fileRoot
			
		local aimJointRoot = xmlFile.createElement "AimJoint"
		local nodesRoot = xmlFile.createElement "Nodes"
		
		aimJointRoot.setAttribute "Root" aimJoint.root
		aimJointRoot.setAttribute "Name" aimJoint.name
		
		local aimJointPosesRoot = xmlFile.createElement "Poses"
		local aimJointIKTargetRoot = xmlFile.createElement "IKTargets"
		
		
		for i = 1 to aimJoint.poses.count do
		(
			local aimJointPose = xmlFile.createElement "Pose"
			aimJointPose.setAttribute "TM" (aimJoint.poses[i] as String)
			aimJointPosesRoot.appendChild aimJointPose
		)
		
		
		for i = 1 to aimJoint.IKTargets.count do
		(
			local tempIKTarget = xmlFile.createElement "IKTarget"
			tempIKTarget.setAttribute "TargetNode" aimJoint.IKTargets[i].targetNode
			tempIKTarget.setAttribute "EffectorNode" aimJoint.IKTargets[i].effectorNode
			tempIKTarget.setAttribute "BlendNode" aimJoint.IKTargets[i].blendNode
			
			for d = 1 to aimJoint.IKTargets[i].poses.count do
			(
				local tempEntry = xmlFile.createElement "Pose"
				tempEntry.setAttribute "TargetTM" (aimJoint.IKTargets[i].poses[d].target as String)
				tempEntry.setAttribute "BlendWeight" (aimJoint.IKTargets[i].poses[d].weight as String)
				
				tempIKTarget.appendChild tempEntry
			)
			
			aimJointIKTargetRoot.appendChild tempIKTarget
		)
		
		
		aimJointRoot.appendChild aimJointPosesRoot
		aimJointRoot.appendChild aimJointIKTargetRoot
		
		fileRoot.appendChild aimJointRoot
		
			
		for i = 1 to nodeArray.count do
		(
			local nodeRoot =  xmlFile.createElement "Node"
			nodeRoot.setAttribute "Name" nodeArray[i].node
			
			for f = 1 to nodeArray[i].aimIKPoses.count do
			(
				local frameRoot = xmlFile.createElement "Key"
				
				frameRoot.setAttribute "TM" (nodeArray[i].aimIKPoses[f] as String)
				
				nodeRoot.appendChild frameRoot
			)
			
			nodesRoot.appendChild nodeRoot
		)
		
		fileRoot.appendChild nodesRoot
		
		try deleteFile filepath catch()
		
		xmlFile.save filepath
	)
	
	
	
	
	
	
	
	function loadAimPoseFile filepath =
	(
		if (getFiles filepath).count > 0 then
		(
			struct tempNodeListStruct (name, frames = #())
			
			local xmlFile = dotNetObject "system.xml.xmlDocument"
			
			xmlFile.load filepath
			
			local fileRoot = xmlFile.documentElement
			local aimJointRoot = fileRoot.childNodes.itemOf[0]
			
			local aimJointPoses = fileRoot.childNodes.itemOf[0]
			
			local aimJointPosesRoot = aimJointRoot.childNodes.itemOf[0]
			local IKTargetRoot = aimJointRoot.childNodes.itemOf[1]
			
			local aimJointRootName = aimJointRoot.attributes.itemOf[0].value
			local aimJointName = aimJointRoot.attributes.itemOf[1].value
			
			
			local aimJointPoses = #()
			
			for i = 0 to (aimJointPosesRoot.childNodes.count - 1) do
			(
				local aimJointPose = aimJointPosesRoot.childNodes.itemOf[i]
				append aimJointPoses (execute aimJointPose.attributes.itemOf[0].value)
			)
			
			
			
			aimJoint.IKTargets = #()
			
			for i = 0 to (IKTargetRoot.childNodes.count - 1) do
			(
				local IKTarget = IKTargetRoot.childNodes.itemOf[i]
				local IKTargetNode = IKTarget.attributes.itemOf[0].value
				local IKEffectorNode = IKTarget.attributes.itemOf[1].value
				local IKBlendNode = IKTarget.attributes.itemOf[2].value
				
				local IKTargetPoses = #()
				
				for d = 0 to (IKTarget.childNodes.count - 1) do
				(
					local IKPose = IKTarget.childNodes.itemOf[d]
					local targetTM = execute(IKPose.attributes.itemOf[0].value)
					local blendWeight = execute(IKPose.attributes.itemOf[1].value)
					
					append IKTargetPoses (IKTargetPoseStruct target:targetTM weight:blendWeight)
				)
				
				append aimJoint.IKTargets (IKTargetNodeStruct targetNode:IKTargetNode effectorNode:IKEffectorNode blendNode:IKBlendNode poses:IKTargetPoses)
			)
			
			
			
			local nodeList = #()
			
			local nodeListRoot = fileRoot.childNodes.itemOf[1]
			
			
			for i = 0 to (nodeListRoot.childNodes.count - 1) do
			(
				local nodeRoot = nodeListRoot.childNodes.itemOf[i]
				local nodeName = nodeRoot.attributes.itemOf[0].value
				local nodeFrames = #()
				
				for f = 0 to (nodeRoot.childNodes.count - 1) do
				(
					local frameRoot = nodeRoot.childNodes.itemOf[f]
					append nodeFrames (execute frameRoot.attributes.itemOf[0].value)
				)
			
				append nodeList (tempNodeListStruct name:nodeName frames:nodeFrames)
			)
			
			
			for i = 1 to nodeArray.count do
			(
				for d = 1 to nodeList.count do
				(
					if nodeArray[i].node == nodeList[d].name then
					(
						nodeArray[i].aimIKPoses = nodeList[d].frames
						exit
					)
				)
			)
			
			aimJoint.root = aimJointRootName
			aimJoint.name = aimJointName
			aimJoint.poses = aimJointPoses
			btnPickRootNode.text = "ROOT:  " + aimJointRootName
			btnPickAimJoint.text = "AIM:  " + aimJointName
			btnAimIKActive.enabled = true
			
			createAimDirNode()
		)
	)
	
	
	
	
	
	function getIKTargetNodes =
	(
		local returnArray = #()
		
		
		local IKTargetPostFix = "IKTarget"
		local IKBlendPostFix = "IKBlend"
		
		local IKTargetArray = #()
		local IKBlendArray = #()
		
		for obj in objects do
		(
			try
			(
				local tempTargetPreFix = subString obj.name 1 (obj.name.count - IKTargetPostFix.count)
				local tempTargetPostFix = subString obj.name (obj.name.count - IKTargetPostFix.count + 1) obj.name.count
				
				if tempTargetPostFix == IKTargetPostFix then
					if findItem IKTargetArray tempTargetPreFix == 0 then
						append IKTargetArray tempTargetPreFix
			)catch()
			
				
				
			try
			(
				local tempBlendPreFix = subString obj.name 1 (obj.name.count - IKBlendPostFix.count)
				local tempBlendPostFix = subString obj.name (obj.name.count - IKBlendPostFix.count + 1) obj.name.count
					
				if tempBlendPostFix == IKBlendPostFix then
					if findItem IKBlendArray tempBlendPreFix == 0 then
						append IKBlendArray tempBlendPreFix
			)catch()
		)
		
		
		local foundMissMatch = #()
		
		for i = 1 to IKTargetArray.count do
		(
			if findItem IKBlendArray IKTargetArray[i] == 0 then
				append foundMissMatch i
		)
		
		IKBlendArray = #()
		
		for i = 1 to IKTargetArray.count do
			if findItem foundMissMatch i == 0 then
				append IKBlendArray IKTargetArray[i]
				
		
		IKTargetArray = deepcopy IKBlendArray
		
		
			
		for i = 1 to IKTargetArray.count do
			append returnArray (IKTargetNodeStruct targetNode:(IKTargetArray[i] + IKTargetPostFix) blendNode:(IKBlendArray[i] + IKBlendPostFix))
		
		
		return returnArray
	)
	
	
	
	
	
	
	
	function importAimPoses =
	(
		if nodeArray.count > 0 then
		(
			for i = 1 to nodeArray.count do
				nodeArray[i].poses = #()
			
			for i = 1 to aimJoint.IKTargets.count do
				aimJoint.IKTargets[i].poses = #()
			
			
			local importNode = getNodeByName aimJoint.root
			
			if importNode != undefined then
			(
					--// biped
				if importNode.classID[1] == 37157 then
				(
					at time (0 as Time)
						local rootTM = importNode.transform
			
					
					local aimJointNode = getNodeByName aimJoint.name
					
					if aimJointNode == undefined then
						return false
					
					aimJoint.poses = #()
					
					
					for f = 0 to 8 do
						at time (f as Time)
							append aimJoint.poses (aimJointNode.transform * inverse rootTM)
					
					
					
					
					for i = 1 to nodeArray.count do
					(
						local newNode = getNodeByName nodeArray[i].node
						
						if newNode != undefined then
						(
							local poses = #()
							
							for f = 0 to 8 do
							(
								at time (f as Time)
								(
									local newRot = newNode.transform.rotation * inverse rootTM.rotation
									local newPos = (newNode.transform * inverse newNode.parent.transform).pos
									
									local newTM = newNode.transform
									newTM.rotation = newRot
									newTM.pos = newPos
									
									append poses newTM--(newNode.transform * inverse rootTM)
									
										--// get IKTarget nodes TM and weight
									if i == 1 then
									(
										for d = 1 to aimJoint.IKTargets.count do
										(
											local IKTargetNode = getNodeByName aimJoint.IKTargets[d].targetNode
											local IKBlendNode = getNodeByName aimJoint.IKTargets[d].blendNode
											
											if IKTargetNode != undefined and IKBlendNode != undefined then
												append aimJoint.IKTargets[d].poses (IKTargetPoseStruct target:(IKTargetNode.transform * inverse IKTargetNode.parent.transform) weight:((IKBlendNode.transform * inverse IKBlendNode.parent.transform).pos.x))
										)
									)
								)
							)
						)
						
						nodeArray[i].aimIKPoses = poses
					)
					
					createAimDirNode()
					
					
					
					return true
				)
			)
		)
		
		return false
	)
	
	
	
	
	
	
	
	function loadBaseAnim =
	(
		struct keyPoseStruct (node, parent, delta = (matrix3 1), keys = #())
		
		local nodeKeyArray = #()
		
		local root = getNodeByName aimJoint.root
		
		if root == undefined then
			return false
		
		
		animationRange = saveAnimRange
		
		for f = saveAnimRange.start to saveAnimRange.end do
		(
			at time f
			(
				for i = 1 to nodeArray.count do
				(
					local tempNode = getNodeByName nodeArray[i].node
					--local tempParentNode = tempNode.parent
									
					--try local tempParentNode = getNodeByName nodeArray[i].parent.node catch()
					local frameCounter = 1
					
					
					
					local keyArray = #()
					
					if tempNode != undefined then
					(	
				
						local localFrame = tempNode.transform * inverse tempParentNode.transform
						
						
						local tempTM = nodeArray[i].localBaseAnim[frameCounter] * inverse nodeArray[i].localBaseAnim[1]
						local newTM =  tempTM * localFrame
						
						append keyArray newTM
					)
					
					frameCounter += 1
				)
			)
			
			nodeArray[i].tempKeys = keyArray
		)
		
		
		local frameCounter = 1
		
		with redraw off
		(
			for i = saveAnimRange.start to saveAnimRange.end do
			(
				sliderTime = i
				--at time i
				(
					for f = 1 to nodeArray.count do
					(
						if nodeArray[f].node != undefined then
						(
							local tempNode = getNodeByName nodeArray[f].node
							local tempParentNode = tempNode.parent
							
							try local tempParentNode = getNodeByName nodeArray[f].parent.node catch()
							
							if f > 1 then
							(
								local deltaTM = nodeArray[f].parent.delta
								
								--local newTM = nodeKeyArray[f].keys[frameCounter] * nodeKeyArray[f].node.parent.transform
								
								
								
								local newTM = inverse (deltaTM * inverse (tempNode.transform * inverse tempParentNode.transform))--nodeArray[f].tempKeys[frameCounter])
								newTM =  nodeArray[f].tempKeys[frameCounter] * (newTM * tempParentNode.transform)
								
								if f == 2 then
									print deltaTM.rotation
							)
							else
								local newTM = nodeArray[f].tempKeys[frameCounter] * tempParentNode.transform
							
							--newTM = newTM * nodeKeyArray[f].node.parent.transform
							
							if tempNode.classID[1] == 37157 then
							(
								local saveTM = tempNode.transform * inverse tempParentNode.transform
								
								--biped.setTransform nodeKeyArray[f].node #pos newTM.pos true
								biped.setTransform tempNode #rotation newTM.rotation true
								
								nodeArray[f].delta = (tempNode.transform * inverse tempParentNode.transform) * inverse saveTM
							)
						)
					)
					
					frameCounter += 1
				)
			)
		)
	)
	
	
	
	
	function createLayer layerName =
	(
		if nodeArray.count > 0 then
		(
			local tempNode = getNodeByName nodeArray[1].node
			if tempNode != undefined then
			(
					--// biped
				if tempNode.classID[1] == 37157 then
				(
					local root = tempNode.controller.rootNode
					local bipIKFound = false
					local ikArray = #(1,2,5,6)
					
					local tempSel = selection as Array
					
					with redraw off
					(
						for i = 1 to ikArray.count do
						(
							select (biped.getNode root.controller ikArray[i] link:1)
							if root.controller.osObject != undefined then
							(
								bipIKFound = true
								exit
							)
						)
					)
					
					if bipIKFound == false then
					(
						biped.createLayer root.controller ((biped.numLayers root.controller) + 1) layerName
						return true
					)
					else
						messageBox "Can't create Layer with IKed limbs"
					
					select tempSel
				)
			)
		)
		
		return false
	)
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	function getNearestPoses root:undefined =
	(
		struct tempAimIKPoseStruct (index = 0, aimJointRot = quat 1)
		
		if root != undefined then
		(
			local poseArray = #()
			local rootTM = root.transform
			
			local returnArray = #()
			local aimDirPos = (rotate (matrix3 1) aimDir).row2
			local aimConeOriginPoseIndex = 5
			
			
			
				--// get all poses in the current root space
			for i = 1 to aimJoint.poses.count do
				append poseArray (tempAimIKPoseStruct index:i aimJointRot:(aimJoint.poses[i] * rootTM).rotation)
			
			
			local aimConeOriginPose = copy poseArray[aimConeOriginPoseIndex]
			
				--// remove the aimCone origin pose as it will always be blended with
			deleteItem poseArray aimConeOriginPoseIndex
			
			
				--// sort the poses rotation so the first has the smalles rotation
			local sortFinished = false
			while sortFinished == false do
			(
				sortFinished = true
				for i = 1 to poseArray.count do
				(
					
					if i < poseArray.count then
					(
						local pose1PosDiff = aimDirPos - (rotate (matrix3 1) poseArray[i].aimJointRot).row2
						local pose2PosDiff = aimDirPos - (rotate (matrix3 1) poseArray[i+1].aimJointRot).row2
						
						if length pose2PosDiff < length pose1PosDiff then
						(
							sortFinished = false
							local tempRot = poseArray[i]
							poseArray[i] = poseArray[i+1]
							poseArray[i+1] = tempRot
						)
					)
				)
			)
			
			
			
				--// append just the first 2 poses for blending
			for i = 1 to 2 do
				append returnArray poseArray[i]
			
				--// the last pose is the aimCone origin frame to make sure, the outer poses get's blended first
			returnArray[3] = aimConeOriginPose
			
			
			return returnArray
		)
		
		return (#())
	)


	
	
	function createAimCone =
	(
		with animate off
		(
			for i = 1 to aimJoint.poses.count do
			(
				local tempPoint = getNodeByName ("AimPosePoint" + i as String)
				if tempPoint == undefined then
					tempPoint = point name:("AimPosePoint" + i as String) wireColor:black cross:true box:false
				
				tempPoint.pos = (rotate (matrix3 1) aimJoint.poses[i].rotation).row2 * 200.0
			)
		)
	)
	
	
	
	
	
	function visPoses poses root:undefined =
	(
		if root != undefined then
		(
			local rootRot = root.transform.rotation
			
			for i = 1 to poses.count do
			(
				local aimPointNode = getNodeByName ("CurAimPosePoint" + i as String)
				if aimPointNode == undefined then
					aimPointNode = point name:("CurAimPosePoint" + i as String) wireColor:yellow cross:false box:true
				
				with animate on
					aimPointNode.pos = ((rotate (matrix3 1) (poses[i].aimJointRot)).row2 * 200.0)
			)
			
			local tempAimJoint = getNodeByName aimJoint.name
			if tempAimJoint != undefined then
			(
				local aimJointNodeTarget = getNodeByName "CurAimJointPos"
				if aimJointNodeTarget == undefined then
				(
					aimJointNodeTarget = point name:"CurAimJointPos" wireColor:red cross:true box:false
					aimJointNode = tape target:aimJointNodeTarget
				)
				
				with animate on
					aimJointNodeTarget.pos = (rotate (matrix3 1) aimDir).row2 * 200.0
			)
			
			if g_aimPoint != undefined then
			(
				local aimPointBlend2 = getNodeByName "AimBlendTarget2"
				if aimPointBlend2 == undefined then
					point pos:(g_aimPoint) name:"AimBlendTarget2" wireColor:green
				else
					with animate on
						aimPointBlend2.pos = g_aimPoint
				
				g_aimPoint = undefined
			)
			
			if g_intersectPoint != undefined then
			(
				local aimPointBlend1 = getNodeByName "AimBlendTarget1"
				if aimPointBlend1 == undefined then
					point pos:(g_intersectPoint) name:"AimBlendTarget1" wireColor:blue
				else
					with animate on
						aimPointBlend1.pos = g_intersectPoint
				
				g_intersectPoint = undefined
			)
		)
	)

	
	function getDet vec1 vec2 =
	(
		return (vec1[1] * vec2[2] - vec1[2] * vec2[1])
	)



	
	
	
	

	function calculateBlendWeights poses root:undefined =
	(
		if root != undefined then
		(
			local rootRot = root.transform.rotation
			local aimDirVec = (rotate (matrix3 1) aimDir).row2
			
				--// get positions of each aimJoint rotation
			local pose1Pos = (rotate (matrix3 1) (poses[1].aimJointRot )).row2
			local pose2Pos = (rotate (matrix3 1) (poses[2].aimJointRot )).row2
			local pose3Pos = (rotate (matrix3 1) (poses[3].aimJointRot )).row2
			
			
				--// get slicePlanePoint
			local triangleU = pose2Pos - pose1Pos
			local triangleV = pose3Pos - pose1Pos
			
			local triangleDot = cross triangleU triangleV
			
			local pA = -(dot triangleDot -pose1Pos)
			local pB = dot triangleDot aimDirVec
			
			
			local dist = pA / pB
			
			
			local intersectPoint = [0,0,0] + dist * aimDirVec		--// works
			
			global g_aimPoint = copy (intersectPoint * 200.0)
			
			
			local p1U = pose2Pos - pose1Pos
			local p1V = intersectPoint - pose3Pos
			local p1W = pose1Pos - pose3Pos
			
			local D = getDet p1U p1V
			local sI = (getDet p1V p1W) / D
			
			local blendPoint1 = pose1Pos + sI * p1U
			
			global g_intersectPoint = copy (blendPoint1 * 200.0)
			
			
				--// clamp weights to 0..1
			local point1_2BlendWeight =length ((blendPoint1 - pose1Pos) / (length (pose2Pos - pose1Pos)))
			local point3_12BlendWeight = length ((intersectPoint - pose3Pos) / (length (blendPoint1 - pose3Pos)))
			
			if point1_2BlendWeight > 1.0 or point3_12BlendWeight > 1.0 then
				print (point1_2BlendWeight as String + "   " + point3_12BlendWeight as String + "  " + poses as String)
			
			
			
			return (#(point1_2BlendWeight, point3_12BlendWeight))
		)
		else
			return (#(0,0))
	)




		--// check, if the dot product of both quats are negative and multiplicate one of the quats by -1
	function normalizeQuat q1 q2 =
	(
		if ((q1.x * q2.x) + (q1.y * q2.y) + (q1.z * q2.z) + (q1.w * q2.w)) < 0 then
			q1 *= -1
		
		return q1
	)

	
	
	
	
	
	
	
	
	
		--// save the base animation and get for each frame the specific blend weights and the 3 pose index to blend with
	function calcAimPoses =
	(
		saveAnimRange = animationRange
		aimIK = #()
		aimIKRoot = #()
		
		local root = getNodeByName aimJoint.root
		
		if root == undefined then
			return false
		
		for i = 1 to nodeArray.count do
		(
			local tempNode = getNodeByName nodeArray[i].node
			nodeArray[i].baseAnim = #()
			nodeArray[i].localBaseAnim = #()
			
			if tempNode != undefined then
			(
				-- save Base Anim
				for f = saveAnimRange.start to saveAnimRange.end do
				(
					at time f
					(
						append nodeArray[i].baseAnim tempNode.transform
						append nodeArray[i].localBaseAnim (tempNode.transform * inverse tempNode.parent.transform)
						
							--// only do this the first time
						if i == 1 then
						(
							updateAimDir()
							local aimIKPoses = getNearestPoses root:root
							local weights = calculateBlendWeights aimIKPoses root:root
							
							append aimIK (aimIKPoseStruct poses:aimIKPoses weights:weights)
							append aimIKRoot root.transform
							
							if g_debugAimPoses == true then
								visPoses aimIKPoses root:root
						)
					)
				)
			)
		)
	)
	
	
	
	
	
	function vecSlerp vec1 vec2 weight =
	(
		local returnVec = vec1
		local cosine = dot (normalize vec1) (normalize vec2)
		
		if cosine >= 0.99 then
			returnVec = (weight * vec1) + ((1-weight) * vec2)
		else
		(
			local rad = acos cosine
			
			local scale_0 = sin ((1.0-weight) * rad)
			local scale_1 = sin (weight * rad)
			
			returnVec = ((vec1 * scale_0) + vec2 * scale_1) / sin (rad)
		)
		
		return returnVec
	)
	
	
	
	
	
		--// blend the transformation with the inputTM and 3 blendTM's and 2 weights
		--// first blend is blendTM[1] - blendTM[2] with weight[1]
		--// second blend is blendTM[3] - first result with weight[2]
	function blendTM inputTM blendTM blendWeights =
	(
		local newRot = quat 1
		local newPos = [0,0,0]
		
		newPos = vecSlerp blendTM[1].pos blendTM[2].pos blendWeights[1]
		newPos = vecSlerp newPos blendTM[3].pos blendWeights[2]
		
		local rot1 = blendTM[1].rotation
		local rot2 = blendTM[2].rotation
		local rot3 = blendTM[3].rotation
		
		rot1 = normalizeQuat rot1 rot2
		newRot = (slerp rot1 rot2 blendWeights[1])
		
		rot3 = normalizeQuat rot3 newRot
		newRot = (slerp rot3 newRot blendWeights[2])
		
		local returnTM = copy inputTM
		returnTM.rotation = newRot
		returnTM.pos = newPos
		
		return returnTM
		
	)
	
	

	
	
	
	
	function applyAimIK =
	(	
		calcAimPoses()
		
		if g_debugAimPoses == true then
			createAimCone()
		
		local root = getNodeByName aimJoint.root
		
		if root == undefined then
			return false
		
		local frameCounter = 1
		
		for i = saveAnimRange.start to saveAnimRange.end do
		(
			--at time i
			sliderTime = i
			(	
				for f = 1 to nodeArray.count do
				(
					local tempNode = getNodeByName nodeArray[f].node
					if tempNode != undefined then
					(
						local aimIKFrames = #()
						
							--// get the 3 TM from base animation according to the blended poses index
						for d = 1 to aimIK[frameCounter].poses.count do
							append aimIKFrames nodeArray[f].aimIKPoses[aimIK[frameCounter].poses[d].index]
						
							--// add the base anim TM to the root TM to get global TM
						local baseAnimTM = nodeArray[f].baseAnim[frameCounter] * inverse aimIKRoot[frameCounter]
						
							--// newTM is the blended result of baseAnim's 3 poses, the global current TM and the 2 blend weights
						local newTM = blendTM baseAnimTM aimIKFrames aimIK[frameCounter].weights
						
						if chkUseInfluences.checked == true then
						(
							local rot1 = normalizeQuat newTM.rotation baseAnimTM.rotation
							local rot1 = slerp baseAnimTM.rotation rot1 (nodeArray[f].influence / 100.0)
							
							newTM.rotation = rot1
						)
						
						
							--// add the current root TM
						local newRot = (newTM * root.transform).rotation
						local newPos = (newTM * tempNode.parent.transform).pos
						
						newTM.rotation = newRot
						newTM.pos = newPos
						
							--// Biped
						if tempNode.classID[1] == 37157 then
						(
							biped.setTransform tempNode #pos newTM.pos true
							biped.setTransform tempNode #rotation newTM.rotation true
						)
					)
				)
				
				
				
				
				
				
				
				if chkUseIKTargets.checked == true then
				(
					for d = 1 to aimJoint.IKTargets.count do
					(
						local effectorNode = getNodeByName aimJoint.IKTargets[d].effectorNode
						local targetNode = getNodeByName aimJoint.IKTargets[d].targetNode
						
						if targetNode != undefined and effectorNode != undefined then
						(
							local aimIKFrames = #()
							local aimIKWeights = #()
							
								--// get the 3 TM from base animation according to the blended poses index
							for f = 1 to aimIK[frameCounter].poses.count do
							(
								append aimIKFrames aimJoint.IKTargets[d].poses[aimIK[frameCounter].poses[f].index].target
								append aimIKWeights aimJoint.IKTargets[d].poses[aimIK[frameCounter].poses[f].index].weight
							)
							
								--// add the base anim TM to the root TM to get global TM
							local baseAnimTM = effectorNode.transform
							
							local blendWeight = 0.0
							
							for f = 1 to aimIKWeights.count do
								blendWeight += aimIKWeights[f]
							
							blendWeight = (blendWeight / aimIKWeights.count) / 100.0
							
							
							if blendWeight > 0.0001 then
							(
								local newTM = blendTM targetNode.parent.transform aimIKFrames aimIK[frameCounter].weights
								
								newTM = newTM * targetNode.parent.transform
								
								
								local newPos =  vecSlerp newTM.pos baseAnimTM.pos blendWeight
							
								local newRot = normalizeQuat newTM.rotation baseAnimTM.rotation
								local newRot = slerp baseAnimTM.rotation newRot blendWeight
								
								newTM.rotation = newRot
								newTM.pos = newPos
							)
							else
								local newTM = effectorNode.transform
						
						
								--// Biped
							if effectorNode.classID[1] == 37157 then
							(
								biped.setTransform effectorNode #pos newTM.pos true
								biped.setTransform effectorNode #rotation newTM.rotation true
							)
						)
					)
				)
			)
			
			frameCounter += 1
		)
		
	)
	
	
	
	
	
	
	function retargetIK =
	(
		local frameCounter = 1
		
		for i = saveAnimRange.start to saveAnimRange.end do
		(
			sliderTime = i
			
			for d = 1 to aimJoint.IKTargets.count do
			(
				local effectorNode = getNodeByName aimJoint.IKTargets[d].effectorNode
				local targetNode = getNodeByName aimJoint.IKTargets[d].targetNode
				
				if targetNode != undefined and effectorNode != undefined then
				(
					local aimIKFrames = #()
					local aimIKWeights = #()
					
						--// get the 3 TM from base animation according to the blended poses index
					for f = 1 to aimIK[frameCounter].poses.count do
					(
						append aimIKFrames aimJoint.IKTargets[d].poses[aimIK[frameCounter].poses[f].index].target
						append aimIKWeights aimJoint.IKTargets[d].poses[aimIK[frameCounter].poses[f].index].weight
					)
					
						--// add the base anim TM to the root TM to get global TM
					local baseAnimTM = effectorNode.transform
					
					local blendWeight = 0.0
					
					for f = 1 to aimIKWeights.count do
						blendWeight += aimIKWeights[f]
					
					blendWeight = (blendWeight / aimIKWeights.count) / 100.0
					
					
					if blendWeight > 0.0001 then
					(
						local newTM = blendTM targetNode.parent.transform aimIKFrames aimIK[frameCounter].weights
						
						newTM = newTM * targetNode.parent.transform
						
						
						local newPos =  vecSlerp newTM.pos baseAnimTM.pos blendWeight
					
						local newRot = normalizeQuat newTM.rotation baseAnimTM.rotation
						local newRot = slerp baseAnimTM.rotation newRot blendWeight
						
						newTM.rotation = newRot
						newTM.pos = newPos
					)
					else
						local newTM = effectorNode.transform
				
				
						--// Biped
					if effectorNode.classID[1] == 37157 then
					(
						biped.setTransform effectorNode #pos newTM.pos true
						biped.setTransform effectorNode #rotation newTM.rotation true
					)
				)
			)
			
			frameCounter += 1
		)
	)
	
	
	
	
	
	
	
	
	
	
	
	function createAimIK =
	(
		undo "Apply AimPose" on
			with redraw off
				applyAimIK()
	)
	
	
	
	function updateAimIK =
	(
		local goOn = true
		
		if chkLayerAimIK.checked == true then
		(
			local bipedLayer = 0
			
			local baseNode = getNodeByName nodeArray[1].node
			
			for i = 1 to (biped.numLayers baseNode.controller) do
			(
				if (biped.getLayerName baseNode.controller i) == "AimIKLayer" then
				(
					bipedLayer = i
					biped.setCurrentLayer baseNode.controller i
					exit
				)
			)
			
			if bipedLayer == 0 then
				goOn = false
		)
		
		if goOn == true then
		(
			undo "Apply AimPose" on
				with redraw off
					applyAimIK()
		)
	)
	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function initVars =
	(
		lvNodes.RowHeadersVisible = false
		lvNodes.ReadOnly = true
		
		local ColumnHeadersDefaultCellStyle = lvNodes.ColumnHeadersDefaultCellStyle
		ColumnHeadersDefaultCellStyle.alignment = ColumnHeadersDefaultCellStyle.alignment.MiddleCenter
		lvNodes.ColumnHeadersDefaultCellStyle = ColumnHeadersDefaultCellStyle
		
		
		local RowTemplate = lvNodes.RowTemplate
		RowTemplate.resizable = RowTemplate.resizable.false
		RowTemplate.height = 20
		
		lvNodes.RowTemplate = RowTemplate
		lvNodes.ColumnHeadersHeightSizeMode = lvNodes.ColumnHeadersHeightSizeMode.DisableResizing
		lvNodes.ColumnHeadersHeight = 20
		
		
		
		
		lvNodes.ColumnCount = 3
		(lvNodes.Columns.item 0).name = "Node"
		(lvNodes.Columns.item 1).name = "Influence"
		(lvNodes.Columns.item 2).name = "Align"
		
		(lvNodes.Columns.item 0).frozen = true
		
		local influenceStyle = (lvNodes.Columns.item 1).DefaultCellStyle
		influenceStyle.Alignment = influenceStyle.Alignment.MiddleCenter
		(lvNodes.Columns.item 1).DefaultCellStyle = influenceStyle
		
		
		local sourcePath = ""
		local sourceFilter = filterString (getSourceFileName()) "\\"
		for i = 1 to (sourceFilter.count - 1) do
			sourcePath += sourceFilter[i] + "\\"
		
		filePath = sourcePath + "aimPose_presets.xml"
		
		loadSettings load:true
		
		updatePreset #nodes
		updatePreset #poses
		
		updateNodeByPreset()
		
		updateAimDir()
	)
	
	
	
	
	
	
	function setAlign nodeArr =
	(
		for i = 1 to nodeArr.count do
		(
			if nodeArr[i].align != undefined then
			(
				local alignNode = getNodeByName nodeArr[i].align
				
				if chkUseSelection.checked == true then
					local curNode = (selection as Array)[1]
				else
					local curNode = getNodeByName nodeArr[i].node
				
				if alignNode != undefined and curNode != undefined then
				(
					local offsetTM = nodeArr[i].offsetTM
					
					if chkUseSelection.checked == true then
						offsetTM.pos.y = (curNode.transform * inverse alignNode.transform).pos.y
					
					local newTM = offsetTM * alignNode.transform
					
				
					
					
					with animate on
					(
						if curNode.classID[1] == 37157 then
						(
							biped.setTransform curNode #pos newTM.pos true
							biped.setTransform curNode #rotation newTM.rotation true
						)
						else
						(	
							local tempTM = matrix3 1
							tempTM.rotation = newTM.rotation
							tempTM.pos = newTM.pos
							scale tempTM curNode.transform.scale
							curNode.transform = tempTM
						)
					)
				)
			)
		)
	)
	
	
	
	
	
	function setPose nodeArr poseIndex orgRot:undefined =
	(	
		for i = 1 to nodeArr.count do
		(
			local rotTM = matrix3 1
			
			rotate rotTM (eulerangles nodeArr[i].poses[poseIndex].pitch 0 0)
			rotate rotTM (eulerangles 0 0 nodeArr[i].poses[poseIndex].yaw)
			
			if chkUseSelection.checked == false then
			(
				if nodeArr[i] != undefined then
				(
					local curNode = getNodeByName nodeArr[i].node
					local defaultTM = nodeArr[i].defaultTM
					
					if chkUseAnimation.checked == true then
						defaultTM = curNode.transform
				
					if curNode != undefined then
					(
						local normalizedNewRot = normalizeQuat (defaultTM * rotTM).rotation   defaultTM.rotation
						local newRot = slerp defaultTM.rotation normalizedNewRot (nodeArr[i].influence / 100.0)
						
						with animate on
						(
							if curNode.classID[1] == 37157 then
								biped.setTransform curNode #rotation newRot true
							else
							(
								local tempTM = matrix3 1
								tempTM.rotation = newRot
								tempTM.pos = curNode.transform.pos
									--// apply original scale back on
								scale tempTM defaultTM.scale
								curNode.transform = tempTM
							)
						)
					)
				)
			)
			else
			(
				for obj in selection do
				(
					if orgRot == undefined then
						local tempRot = obj.transform.rotation
					else
						local tempRot = orgRot
					
					local normalizedNewRot = normalizeQuat (alignNodeDefaultTM * rotTM).rotation tempRot
					local newRot = slerp alignNodeDefaultTM.rotation normalizedNewRot (nodeArr[1].influence / 100.0)
					
					
					with animate on
					(
						if obj.classID[1] == 37157 then
							biped.setTransform obj #rotation newRot true
						else
						(
							local tempTM = matrix3 1
							tempTM.rotation = newRot
							tempTM.pos = obj.transform.pos
							scale tempTM obj.transform.scale
							obj.transform = tempTM
						)
					)
				)
			)
		)
		
		if chkUseAlign.checked == true then
			setAlign nodeArray
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	function createPose poseIndex nodeIndex:undefined all:undefined =
	(
		if nodeIndex == undefined then
		(
			undo "set pose" on
			(
				if all == undefined then
					setPose nodeArray poseIndex
				else
				(
					if nodeArray.count > 0 then
					(
						if nodeArray[1].poses.count > 0 then
						(
							animationRange = interval 0 (nodeArray[1].poses.count - 1)
							for i = 1 to nodeArray[1].poses.count do
							(
								sliderTime = ((i-1) as Time)
								setPose nodeArray i 
							)
						)
					)
				)	
			)
		)
	)

	
	
	
	
	on aimPoses open do
		initVars()
	
	
	
	
	on btnSettings pressed do
	(
		rcmenu settingsRC
		(
			menuItem miClear "Clear"
			menuItem miOpen "Open"
			separator sep1
			menuItem miSave "Save"
			menuItem miSaveAs "Save As..."
			
			
			on miClear picked do
			(
				nodePresets = #()
				posePresets = #()
				
				updatePreset #nodes
				updatePreset #poses
				
				if nodeArray.count == 0 then
				(
					ddNodePreset.selection = 1
					ddPosePreset.selection = 1
				)
				else
				(
					ddNodePreset.selection = 2
					
					if nodeArray[1].poses.count == 0 then
						ddPosePreset.selection = 1
					else
						ddPosePreset.selection = 2
				)
			)
			
			
			on miOpen picked do
				loadSettings()
			
			
			on miSave picked do
				saveSettings()
			
			on miSaveAs picked do
				saveSettings saveAs:true
			
		)
		
		
		registerRightClickMenu settingsRC

		popUpMenu settingsRC pos:[(mouse.screenpos[1] - 2), (mouse.screenpos[2] - 2)]
	)
	
	
	
	
	
	on btnNodeSettings pressed do
	(
		rcmenu nodeSettingsRC
		(
			menuItem miDelete "Delete"
			separator miSep2
			menuItem miRename "Rename"
			menuItem miSaveAs "Save As..."
			
			
			
			on miSaveAs picked do
			(
				try destroyDialog saveAsNodePresetRO catch()
				
				rollout saveAsNodePresetRO "Save Node Preset"
				(
					edittext edSaveNode "" pos:[2,7] height:17 fieldWidth:140
					dropdownlist ddSaveNode "" pos:[5,5] height:10 width:160
					
					button btnOk "Ok" pos:[175,5] height:20 width:50
					button btnCancel "Cancel" pos:[230,5] height:20 width:50
					
					on saveAsNodePresetRO open do
					(
						local newArray = #()
						
						if ddNodePreset.items.count > 2 then
						(
							for i = 3 to ddNodePreset.items.count do
								append newArray ddNodePreset.items[i]
						)
						
						ddSaveNode.items = newArray
						if ddNodePreset.selection > 2 then
						(
							ddSaveNode.selection = ddNodePreset.selection - 2
							edSaveNode.text = ddSaveNode.selected
						)
					)
					
					
					
					on ddSaveNode selected value do
						edSaveNode.text = ddSaveNode.selected
					
					
					on btnOk pressed do
					(
						local selIndex = 0
						local overwrite = false
						local ready = true
						
						for i = 1 to nodePresets.count do
						(
							if edSaveNode.text == nodePresets[i].name then
							(
								if (queryBox "Override existing Preset ?") == true then
								(
									nodePresets[i].name = edSaveNode.text
									nodePresets[i].nodes = deepCopy nodeArray
									
									if ddPosePreset.selection != 2 then
										nodePresets[i].usedPoses = ddPosePreset.selection
									else
										nodePresets[i].usedPoses = 1
									
									selIndex = i + 2
									overwrite = true
								)
								else
									ready = false
								
								exit
							)
						)
						
						if ready == true then
						(
							--// nothing found and append now
							if selIndex == 0 then
							(
								local poseSel = 1
								if ddPosePreset.selection != 2 then
									poseSel = ddPosePreset.selection
								
								append nodePresets (nodePresetStruct name:edSaveNode.text usedPoses:poseSel nodes:(deepCopy nodeArray))
								updatePreset #nodes
								selIndex = ddNodePreset.items.count
								destroyDialog saveAsNodePresetRO
							)
							
							ddNodePreset.selection = selIndex
							
							if overwrite == true then
								destroyDialog saveAsNodePresetRO
						)
					)
					
					
					on btnCancel pressed do
						destroyDialog saveAsNodePresetRO
				)
				
				
				createDialog saveAsNodePresetRO 285 28
			)
			
			
			on miDelete picked do
			(
				if ddNodePreset.selection > 2 then
				(
					if (queryBox ("Delete " + nodePresets[ddNodePreset.selection - 2].name + " ?")) == true then
					(
						deleteItem nodePresets (ddNodePreset.selection - 2)
						updatePreset #nodes
						ddNodePreset.selection = 2
					)
				)
			)
			
			
			on miRename picked do
			(
				if ddNodePreset.selection > 2 then
				(
					rollout renameNodePresetRO "New Node Preset"
					(
						edittext edRenameNode "" pos:[2,5] height:18 fieldWidth:160
						
						button btnOk "Ok" pos:[175,5] height:20 width:50
						button btnCancel "Cancel" pos:[230,5] height:20 width:50
						
						on renameNodePresetRO open do
						(
							if ddNodePreset.selection > 2 then
								edRenameNode.text = ddNodePreset.selected
						)
						
						on btnOk pressed do
						(
							if aimPoses.ddNodePreset.selected != edRenameNode then
							(
								for i = 1 to nodePresets.count do
								(
									if edRenameNode.text == nodePresets[i].name then
									(
										messageBox "Node is already in the list"
										exit
									)
								)
							)
							
							nodePresets[ddNodePreset.selection - 2].name = edRenameNode.text
							updatePreset #nodes
							
							destroyDialog renameNodePresetRO
						)
						
						
						on btnCancel pressed do
							destroyDialog renameNodePresetRO
					)
					
					
					createDialog renameNodePresetRO 285 28
				)
			)
		)
		
		
		registerRightClickMenu nodeSettingsRC

		popUpMenu nodeSettingsRC pos:[(mouse.screenpos[1] - 2), (mouse.screenpos[2] - 2)]
	)
	
	
	
	
	
	
	
	
	
	on btnPoseSettings pressed do
	(
		rcmenu poseSettingsRC
		(
			menuItem miDelete "Delete"
			separator miSep2
			menuItem miRename "Rename"
			menuItem miSaveAs "Save As..."
			
			
			
			on miSaveAs picked do
			(
				try destroyDialog saveAsPosePresetRO catch()
				
				rollout saveAsPosePresetRO "Save Pose Preset"
				(
					edittext edSavePose "" pos:[2,7] height:17 fieldWidth:140
					dropdownlist ddSavePose "" pos:[5,5] height:10 width:160
					
					button btnOk "Ok" pos:[175,5] height:20 width:50
					button btnCancel "Cancel" pos:[230,5] height:20 width:50
					
					on saveAsPosePresetRO open do
					(
						local newArray = #()
						
						if ddPosePreset.items.count > 2 then
						(
							for i = 3 to ddPosePreset.items.count do
								append newArray ddPosePreset.items[i]
						)
						
						ddSavePose.items = newArray
						if ddPosePreset.selection > 2 then
						(
							ddSavePose.selection = ddPosePreset.selection - 2
							edSavePose.text = ddSavePose.selected
						)
					)
					
					
					
					on ddSavePose selected value do
						edSavePose.text = ddSavePose.selected
					
					
					on btnOk pressed do
					(
						local selIndex = 0
						local overwrite = false
						local ready = true
						
						for i = 1 to posePresets.count do
						(
							if edSavePose.text == posePresets[i].name then
							(
								if (queryBox "Override existing Preset ?") == true then
								(
									posePresets[i].name = edSavePose.text
									posePresets[i].poses = deepCopy nodeArray[1].poses
								
									selIndex = i + 2
									overwrite = true
								)
								else
									ready = false
								
								exit
							)
						)
						
						if ready == true then
						(
								--// nothing found and append now
							if selIndex == 0 then
							(
								append posePresets (posePresetStruct name:edSavePose.text poses:( if nodeArray.count > 0 then deepCopy nodeArray[1].poses else (#())))
								updatePreset #poses
								selIndex = ddPosePreset.items.count
								destroyDialog saveAsPosePresetRO
							)
							
							ddPosePreset.selection = selIndex
							
							if overwrite == true then
								destroyDialog saveAsPosePresetRO
						)
					)
					
					
					on btnCancel pressed do
						destroyDialog saveAsPosePresetRO
				)
				
				
				createDialog saveAsPosePresetRO 285 28
			)
			
			
			on miDelete picked do
			(
				if ddPosePreset.selection > 2 then
				(
					if (queryBox ("Delete " + posePresets[ddPosePreset.selection - 2].name + " ?")) == true then
					(
						deleteItem posePresets (ddPosePreset.selection - 2)
						updatePreset #poses
						ddPosePreset.selection = 2
					)
				)
			)
			
			
			on miRename picked do
			(
				if ddPosePreset.selection > 2 then
				(
					rollout renamePosePresetRO "Rename Pose Preset"
					(
						edittext edRenamePose "" pos:[2,5] height:18 fieldWidth:160
						
						button btnOk "Ok" pos:[175,5] height:20 width:50
						button btnCancel "Cancel" pos:[230,5] height:20 width:50
						
						on renamePosePresetRO open do
						(
							if ddPosePreset.selection > 2 then
								edRenamePose.text = ddPosePreset.selected
						)
						
						
						on btnOk pressed do
						(
							if aimPoses.ddPosePreset.selected != edRenamePose then
							(
								for i = 1 to posePresets.count do
								(
									if edRenamePose.text == posePresets[i].name then
									(
										messageBox "Pose is already in the list"
										exit
									)
								)
							)
							
							posePresets[ddPosePreset.selection - 2].name = edRenamePose.text
							updatePreset #poses
							
							destroyDialog renamePosePresetRO
						)
						
						
						on btnCancel pressed do
							destroyDialog renamePosePresetRO
					)
					
					
					createDialog renamePosePresetRO 285 28
				)
			)
		)
		
		registerRightClickMenu poseSettingsRC

		popUpMenu poseSettingsRC pos:[(mouse.screenpos[1] - 2), (mouse.screenpos[2] - 2)]
	)
	
	
	
	
	
	
	
	
	on ddNodePreset selected value do
	(
		updateNodeByPreset clearList:true
		updateNodeByPreset()
	)
	
	on ddPosePreset selected value do
		updatePoseByPreset()
	
	
	
	on lvNodes ColumnHeaderMouseClick value do
	(
		try
		(
			((lvNodes.Rows.item 0).cells.item 0).selected = true
			((lvNodes.Rows.item 0).cells.item 0).selected = false
		)catch()
		
		for i = 0 to (lvNodes.Columns.count - 1) do
		(
			for f = 0 to (lvNodes.Rows.count - 2) do
				((lvNodes.Rows.item f).cells.item i).selected = (if i == value.ColumnIndex then true else false)
		)
	)
	
	
	on spnPoseCount changed value do
	(
		for i = 1 to nodeArray.count do
		(
			local start = value
			local end = nodeArray[i].poses.count
			local remove = true
			
			if value > nodeArray[i].poses.count then
			(
				start = nodeArray[i].poses.count
				end = value
				remove = false
			)
			
			local counter = end
			
			for f = (start+1) to end do
			(
				if remove == true then
					deleteItem nodeArray[i].poses counter
				else
					append nodeArray[i].poses (poseStruct())
				
				counter -= 1
			)
		)
		
		if ddPosePreset.selection != 2 then
			ddPosePreset.selection = 2
		
		updateList()
	)
	
	
	on lvNodes SelectionChanged value do
		getValues()
	
	
	on spnInfluence changed value do
		setValue #influence
	
	on spnYaw changed value do
		setValue #yaw
	
	on spnPitch changed value do
		setValue #pitch
	
	
	
	on btnRemoveNode pressed do
	(
		local removeArray = #()
		local newArray = #()
		
		for i = 0 to (lvNodes.selectedCells.count - 1) do
		(	
			if (findItem removeArray (lvNodes.selectedCells.item i).rowIndex) == 0 then
				append removeArray (lvNodes.selectedCells.item i).rowIndex
		)
		
		for i = 1 to nodeArray.count do
		(
			if findItem removeArray (i-1) == 0 then
				append newArray nodeArray[i]
		)
		
		nodeArray = newArray
		
		updateOffsets()
		
		if nodeArray.count > 0 then
			updateList()
		else
		(
			ddNodePreset.selection = 1
			updateNodeByPreset()
		)
	)
	
	
	
	
	on btnAddNode pressed do
	(
		for obj in selection do
		(
			local nodeFound = false
			
			for i = 1 to nodeArray.count do
			(
				if nodeArray[i].node == obj.name then
				(
					nodeFound = true
					exit
				)
			)
			
			if nodeFound == false then
			(
				local influence = 100.0
				local poses = #()
				
				for i = 1 to spnPoseCount.value do
					append poses (poseStruct())
				
				
				if nodeArray.count > 0 then
				(
					influence = nodeArray[nodeArray.count].influence
					poses = nodeArray[nodeArray.count].poses
				)
				
				append nodeArray (nodeStruct node:obj.name influence:influence poses:poses)
			)
			else
				messageBox "Node already in the list"
		)
		
		updateOffsets()
		updateList()
	)
	
	
	
	on btnSetNode pressed do
	(
		if lvNodes.selectedCells.count > 0 then
		(
			for obj in selection do
			(
				local nodeFound = false
				
				for i = 1 to nodeArray.count do
				(
					if nodeArray[i].node == obj.name then
					(
						nodeFound = true
						exit
					)
				)
				
				if nodeFound == false then
				(
					if (lvNodes.selectedCells.item 0).rowIndex + 1 > nodeArray.count then
						exit
					
					nodeArray[(lvNodes.selectedCells.item 0).rowIndex+1].node = obj.name
					exit
				)
			)
			
			updateOffsets()
			updateList()
		)
	)
	
	
	
	
	
	
	on btnSetAlign pressed do
	(
		if lvNodes.selectedCells.count > 0 then
		(
			for obj in selection do
			(	
				if (lvNodes.selectedCells.item 0).rowIndex + 1 > nodeArray.count then
					exit
				
				if nodeArray[(lvNodes.selectedCells.item 0).rowIndex+1].align != obj.name then
				(
					nodeArray[(lvNodes.selectedCells.item 0).rowIndex+1].align = obj.name
					
					if chkUseSelection.checked == true then
						alignNodeTo = obj.name
					
					exit
				)
			)
			
			if chkUseSelection.checked == false then
				updateOffsets()
			
			updateList()
		)
	)
	
	
	
	
	on btnRemoveAlign pressed do
	(
		if lvNodes.selectedCells.count > 0 then
		(
			
			
			for i = 0 to (lvNodes.selectedCells.count - 1) do
			(
				if (lvNodes.selectedCells.item i).rowIndex + 1 > nodeArray.count then
					exit
				
				nodeArray[(lvNodes.selectedCells.item i).rowIndex + 1].align = undefined
				nodeArray[(lvNodes.selectedCells.item i).rowIndex + 1].offsetTM = matrix3 1
				
				if chkUseSelection.checked == true then
					nodeArray[(lvNodes.selectedCells.item i).rowIndex + 1].rotOffset = quat 1
			)
		)
		
		updateList()
	)
	
	

	
	
	on chkUseSelection changed active do
	(
		ddNodePreset.enabled = not active
		btnNodeSettings.enabled = not active
		
		updateNodeByPreset useSel:active
	)
	
	
	on btnRemoveOffsetSel pressed do
	(
		for i = 0 to (lvNodes.selectedCells.count - 1) do
		(
			local index = (lvNodes.selectedCells.item i).rowIndex + 1
			nodeArray[index].rotOffset = (quat 1)
			nodeArray[index].offsetTM = (matrix3 1)
		)
		
		getValues()
	)
		
	on btnUpdateSel pressed do
		updateOffsets()
	
	on btnUpdateAll pressed do
		updateOffsets range:#all
	
	
	on btnRemoveOffsetAll pressed do
	(
		for i = 1 to nodeArray.count do
		(
			nodeArray[i].rotOffset = (quat 1)
			nodeArray[i].offsetTM = (matrix3 1)
		)
		
		getValues()
	)
	
	

	
	
	on btnPose01 pressed do		createPose 1
	on btnPose02 pressed do		createPose 2
	on btnPose03 pressed do		createPose 3
	on btnPose04 pressed do		createPose 4
	on btnPose05 pressed do		createPose 5
	on btnPose06 pressed do		createPose 6
	on btnPose07 pressed do		createPose 7
	on btnPose08 pressed do		createPose 8
	on btnPose09 pressed do		createPose 9
	on btnPose10 pressed do		createPose 10
	
	on btnPose11 pressed do		createPose 11
	on btnPose12 pressed do		createPose 12
	on btnPose13 pressed do		createPose 13
	on btnPose14 pressed do		createPose 14
	on btnPose15 pressed do		createPose 15
	on btnPose16 pressed do		createPose 16
	on btnPose17 pressed do		createPose 17
	on btnPose18 pressed do		createPose 18
	on btnPose19 pressed do		createPose 19
	on btnPose20 pressed do		createPose 20
	
	on btnPose21 pressed do		createPose 21
	on btnPose22 pressed do		createPose 22
	on btnPose23 pressed do		createPose 23
	on btnPose24 pressed do		createPose 24
	on btnPose25 pressed do		createPose 25
	on btnPose26 pressed do		createPose 26
	on btnPose27 pressed do		createPose 27
	on btnPose28 pressed do		createPose 28
	on btnPose29 pressed do		createPose 29
	on btnPose30 pressed do		createPose 30
		
	on btnPose31 pressed do		createPose 31
	on btnPose32 pressed do		createPose 32
	on btnPose33 pressed do		createPose 33
	on btnPose34 pressed do		createPose 34
	on btnPose35 pressed do		createPose 35
	on btnPose36 pressed do		createPose 36
	on btnPose37 pressed do		createPose 37
	on btnPose38 pressed do		createPose 38
	on btnPose39 pressed do		createPose 39
	on btnPose40 pressed do		createPose 40
		
	on btnPose41 pressed do		createPose 41
	on btnPose42 pressed do		createPose 42
	on btnPose43 pressed do		createPose 43
	on btnPose44 pressed do		createPose 44
	on btnPose45 pressed do		createPose 45
	on btnPose46 pressed do		createPose 46
	on btnPose47 pressed do		createPose 47
	on btnPose48 pressed do		createPose 48
	on btnPose49 pressed do		createPose 49
	on btnPose50 pressed do		createPose 50
		
	on btnPose51 pressed do		createPose 51
	on btnPose52 pressed do		createPose 52
	on btnPose53 pressed do		createPose 53
	on btnPose54 pressed do		createPose 54
	on btnPose55 pressed do		createPose 55
	on btnPose56 pressed do		createPose 56
	on btnPose57 pressed do		createPose 57
	on btnPose58 pressed do		createPose 58
	on btnPose59 pressed do		createPose 59
	on btnPose60 pressed do		createPose 60
	
	
	on btnCreatePoses pressed do
		createPose 1 all:true
		
	
	on btnSelectionToAlign pressed do
	(
		undo "selection to align" on
			setAlign nodeArray
	)
	
	
	
	
	on btnAimIKSettings changed value do
	(
		if value == true then
			aimPoses.height = 378
		else
			aimPoses.height = 330
	)
	
	
	
	
	on btnAimIKActive changed value do
	(
		if value == true then
		(
			local goOn = true
			
			if chkLayerAimIK.checked == true then
				goOn = createLayer "AimIKLayer"
			
			if goOn != false then
			(
				undo "Apply AimPose" on
					with redraw off
						applyAimIK()
			)
			
			
			if chkLayerAnim.checked == true and goOn == true then
			(
				if createLayer "existingAnim" == true then
					loadBaseAnim()
			)
			
			if goOn == false then
			(
				value = not value
				btnAimIKActive.checked = false
			)
		)
		
		chkLayerAnim.enabled = not value
		chkLayerAimIK.enabled = not value
		chkUseInfluences.enabled = not value
		btnAimIKUpdate.enabled = value
	)
	
	
	
	on btnPickAimJoint pressed do
	(
		local tempJoint = undefined
		
		if selection.count > 0 then
			tempJoint = (selection as Array)[1]
		else
			tempJoint = selectByName showHidden:true single:true
		
		
		if tempJoint != undefined then
		(
			aimJoint.name = tempJoint.name
			btnPickAimJoint.text = "AIM:  " + aimJoint.name
		)
		else
		(
			aimJoint.name = ""
			btnPickAimJoint.text = "Aim Joint"
		)
		
		
		if aimJoint.root != "" and aimJoint.name != "" then
			btnImportAimPoses.enabled = true
		
	)
	
	
	
	
	on btnPickRootNode pressed do
	(
		local tempJoint = undefined
		
		if selection.count > 0 then
			tempJoint = (selection as Array)[1]
		else
			tempJoint = selectByName showHidden:true single:true
		
		
		if tempJoint != undefined then
		(
			aimJoint.root = tempJoint.name
			btnPickRootNode.text = "ROOT:  " + aimJoint.root
		)
		else
		(
			aimJoint.root = ""
			btnPickAimJoint.text = "Aim Node"
		)
		
		if aimJoint.root != "" and aimJoint.name != "" then
			btnImportAimPoses.enabled = true
		
	)
	
	
	
	
	
	on btnImportAimPoses pressed do
	(
		rcmenu aimIKImportRC
		(
			menuItem miImport "Import from Scene" enabled:false
			separator sep1
			menuItem miLoad "Load aimPose File"
			menuItem miSave "Save aimPose File" enabled:false
			
			
			on aimIKImportRC open do
			(
				if aimJoint.name != "" and aimJoint.root != "" then
				(
					miImport.enabled = true
					miSave.enabled = true
				)
			)
			
			
			on miImport picked do
			(
				if importAimPoses() == true then
				(
					btnAimIKActive.enabled = true
					btnAimIKUpdate.enabled = true
					
				)
				else
				(
					btnAimIKActive.enabled = false
				)
			)
			
			
			on miLoad picked do
			(
				local loadPath = getOpenFileName caption:"Open Aim Pose File" types:"AimPoses File (*.aim)|*.aim"
				if loadPath != undefined then
					loadAimPoseFile loadPath
			)
			
			on miSave picked do
			(
				local savePath = getSaveFileName caption:"Save Aim Pose File" types:"AimPoses File (*.aim)|*.aim"
				if savePath != undefined then
					saveAimPoseFile savePath
			)
		)
		
		
		registerRightClickMenu aimIKImportRC

		popUpMenu aimIKImportRC pos:[(mouse.screenpos[1] - 2), (mouse.screenpos[2] - 2)]

	)
	
	
	
	
	
	on btnAimIKUpdate pressed do
	(
		updateAimIK()
		
		
	)
	
	
	
	on chkUseIKTargets changed value do
	(
		if value == true then
			btnAimIKActive.enabled = (aimJoint.IKTargets.count > 0)
		else
			btnAimIKActive.enabled = (aimJoint.root != "" and aimJoint.name != "" and aimJoint.poses.count > 0)
	)
	
	
	
	
	on btnSetIKTargets pressed do
	(
		try destroyDialog setIKTargetRO catch()
		
		rollout setIKTargetRO "IK Target Nodes"
		(
			dotNetControl lvIKTargets "System.Windows.Forms.DataGridView" pos:[5,5] width:605 height:155
			
			button btnAddNode "+" pos:[5,168] height:14 width:14
			button btnSetNode "Set Node" pos:[19,165] height:20 width:150
			button btnRemoveNode "-" pos:[150+19,168] height:14 width:14
			
			button btnGetIKTargets "Get IK Targets" pos:[250,165] height:20 width:80
			
			button btnOk "Ok" pos:[5+430+5,115+50] height:20 width:80
			button btnCancel "Cancel" pos:[5+430+90+5,115+50] height:20 width:80
			
			
			function addIKTargets nodeList:undefined =
			(
				if nodeList == undefined then
					local nodeList = aimJoint.IKTargets
				
				if nodeList.count > 0 then
					lvIKTargets.RowCount = (nodeList.count + 1)
				
				
				
				
				for i = 1 to nodeList.count do
				(
					((lvIKTargets.rows.item (i - 1)).cells.item 0).value = nodeList[i].targetNode
					((lvIKTargets.rows.item (i - 1)).cells.item 1).value = nodeList[i].effectorNode
					((lvIKTargets.rows.item (i - 1)).cells.item 2).value = nodeList[i].blendNode
				)
			)
			
			
			
			on setIKTargetRO open do
			(	
				lvIKTargets.RowHeadersVisible = false
				lvIKTargets.ReadOnly = true
				lvIKTargets.MultiSelect = true
				
				
				global tempShit = lvIKTargets
				local RowTemplate = lvIKTargets.RowTemplate
				RowTemplate.resizable = RowTemplate.resizable.false
				RowTemplate.height = 20
				
				lvIKTargets.RowTemplate = RowTemplate
				lvIKTargets.ColumnHeadersHeightSizeMode = lvIKTargets.ColumnHeadersHeightSizeMode.DisableResizing
				lvIKTargets.ColumnHeadersHeight = 20
				
				
				
				
				lvIKTargets.ColumnCount = 3
				(lvIKTargets.Columns.item 0).name = "Target"
				(lvIKTargets.Columns.item 1).name = "Effector"
				(lvIKTargets.Columns.item 2).name = "Weight"
				
				(lvIKTargets.Columns.item 0).width = 195
				(lvIKTargets.Columns.item 1).width = 195
				(lvIKTargets.Columns.item 2).width = 195
				
				
				
				
				addIKTargets()
			)
			
			
			
			on btnAddNode pressed do
			(
				lvIKTargets.RowCount += 1
			)
			
			
			
			on btnSetNode pressed do
			(
				if lvIKTargets.selectedCells.count > 0 then
				(
					for i = 0 to (lvIKTargets.selectedCells.count - 1) do
					(
						local tempCell = lvIKTargets.selectedCells.item i
						
						if tempCell.rowIndex < (lvIKTargets.rows.count - 1) then
						(
							local curSel = getCurrentSelection()
							local tempNode = (getCurrentSelection())[1]
							if tempNode == undefined then
								tempNode = selectByName showHidden:true single:true
							
							if tempNode != undefined then
								tempCell.value = tempNode.name
							else
								tempCell.value = ""
						)
					)
				)
			)
			
			
			
			on btnRemoveNode pressed do
			(
				global tempShit = lvIKTargets
				local removeRowArray = #()
				
				for i = 0 to (lvIKTargets.selectedCells.count - 1) do
				(
					local tempCell = lvIKTargets.selectedCells.item i
					tempCell.value = undefined
					
					local rowEmpty = true
					
					for d = 0 to (lvIKTargets.columns.count - 1) do
					(
						local rowCell = ((lvIKTargets.rows.item tempCell.rowIndex).cells.item d)
						if rowCell.value != undefined and rowCell.value != "" then
							rowEmpty = false
					)
					
					if rowEmpty == true then
					(
						--if lvIKTargets.rows.count > 1 then
						append removeRowArray tempCell.rowIndex
						
					)
				)
				
				sort removeRowArray
				
				
				for i = removeRowArray.count to 1 by -1 do
				(
					if lvIKTargets.rows.count > 1 then
					(
						if removeRowArray[i] < (lvIKTargets.rows.count - 1) then
							lvIKTargets.rows.removeAt removeRowArray[i]
					)
					else
					(
						lvIKTargets.RowCount = 1
						lvIKTargets.Rows.Clear()
					)
				)
			)
			
			
			
			
			on btnGetIKTargets pressed do
			(
				lvIKTargets.RowCount = 1
				lvIKTargets.Rows.clear()
				
				addIKTargets nodeList:(getIKTargetNodes())
			)
			
			
			
			
			
			on btnOk pressed do
			(
				aimJoint.IKTargets = #()
				
				for i = 0 to (lvIKTargets.rows.count - 2) do
				(
					local tempRow = lvIKTargets.rows.item i
					
					local targetNode = (tempRow.cells.item 0).value ;	if targetNode == undefined or targetNode == "" then targetNode = ""
					local effectorNode = (tempRow.cells.item 1).value ;	if effectorNode == undefined or effectorNode == "" then effectorNode = ""
					local blendNode = (tempRow.cells.item 2).value ;		if blendNode == undefined or blendNode == "" then blendNode = ""
					
					
					if targetNode != "" or effectorNode != "" or blendNode != "" then
						append aimJoint.IKTargets (IKTargetNodeStruct targetNode:targetNode effectorNode:effectorNode blendNode:blendNode)
				)
				
				try destroyDialog setIKTargetRO catch()
			)
			
			
			
			
			on btnCancel pressed do
			(
				try destroyDialog setIKTargetRO catch()
			)
		)
		
		
		createDialog setIKTargetRO 615 190
	)
	
	
	
	
	
	
	on btnSelectionToAlignZero pressed do
	(
		local newTM = matrix3 1
		
		if nodeArray[1].align != undefined then
			newTM = nodeArray[1].offsetTM--(matrix3 1) * nodeArray[1].posOffset
		
		undo "zero selection" on
		(
			with animate on
			(
				for obj in selection do
				(
					if obj.classID[1] == 37157 then
						biped.setTransform obj #rotation newTM.rotation true
					else
					(
						local tempTM = obj.transform
						tempTM.rotation = newTM.rotation
						tempTM.pos = obj.transform.pos
						obj.transform = tempTM
					)
				)
			)
		)
	)
)


createDialog aimPoses 550 330