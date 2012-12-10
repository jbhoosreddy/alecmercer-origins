rollout rltCryPickableSetup_rollout "Pickable Object Setup" width:190
(
	local origViewTM = getViewTM()
	local c2PickableNanoObjects = #()
	local c2PickableOrigObjects = #()
	
	group "Pickable Dummies"
	(
		button btn_c2Open2HPose "2H Pose..." offset:[-5,1] width:80 height:16 align:#left across:2 tooltip:""
		button btn_c2Make2HDummies "2H Dummy" offset:[0,1] width:80 height:16 align:#left tooltip:""

		button btn_c2Open1HPose "1H Pose..." offset:[-5,1] width:80 height:16 align:#left across:2 tooltip:""
		button btn_c2Make1HDummies "1H Dummy" offset:[0,1] width:80 height:16 align:#left tooltip:""

		button btn_c2Open1HPolePose "Pole Pose..." offset:[-5,1] width:80 height:16 align:#left across:2 tooltip:""
		button btn_c2Make1HPoleDummies "Pole Dummy" offset:[0,1] width:80 height:16 align:#left tooltip:""
	)
	group "Camera Controls"
	(
		button btn_c2Set1pCam "1P Camera" width:160 height:16 align:#center tooltip:""
		button btn_c2SetPerspCam "Persp Cam" width:160 height:16 align:#center tooltip:""
	)
	group "Pickable Pose"
	(
		button btn_c2PreviewPos "Snap to Grab Pose" width:160 height:16 align:#center tooltip:""
		button btn_c2ResetPos "Reset Object for Export" width:160 height:16 align:#center tooltip:""
	)
	
	button btn_c2CleanupPickableScene "Remove Nanosuit" width:160 height:16 align:#center tooltip:""

	/********************************************************************************/
	
	fn c2PickP4Cmd cmd filename = 
	(
		local p4cmd = ("p4 " + cmd + " " + filename + " > hiddencmdout.tmp")
		try
			(HiddenDOSCommand ( p4cmd ))	-- Max 2010
		catch
			(DOSCommand ( p4cmd ))				-- Max 2008

		fid = openFile "hiddencmdout.tmp" mode:"rt"
		if fid == undefined then
		(
			print ("CANNOT FIND hiddencmdout.tmp")
			return undefined
		)
		
		local strStream = ""
		while not (eof fid) do
			strStream = strStream + (readLine fid)
		close fid
		
		if strStream == "" then
			strStream = undefined
		
		return strStream
	)
	
	fn fnC2GetPickPose type =
	(
		p4PoseFile = "//data/Games/Crysis2/GameCrysis2/_Animations_source/human/male/weapons/hands/"
		case type of
		(
			"1H" 	: p4PoseFile = (p4PoseFile + "stand_tac_pick_idlePose_small_1p_01.max")
			"2H" 	: p4PoseFile = (p4PoseFile + "stand_tac_pick_idlePose_medium_1p_01.max")
			"pole" : p4PoseFile = (p4PoseFile + "stand_tac_pick_idlePose_pole_add_1p_01.max")
		)

		response = yesNoCancelBox ("Do you wish to Open the nanosuit figure (OPEN = YES), or Merge it with the current scene (MERGE = NO) ?")
		if response == #cancel then
			return()

		localPoseFile = ""
		
		strStream = c2PickP4Cmd "sync -f" p4PoseFile
		if strStream == undefined then
			strStream = ""
			
		if (idx = findString strStream "refreshing ") != undefined then
		(
			localPoseFile = substring strStream (idx + 11) strStream.count
		) else (
			strStream = c2PickP4Cmd "have" p4PoseFile
			print ("strStream = " + strStream)
			if strStream == undefined then
				return()
			aStrStream = filterString strStream "-"
			if aStrStream.count == 2 then
			(
				localPoseFile = trimLeft aStrStream[2] " "
			)
		)
		print ("Loading: " + localPoseFile)
		
		if (doesFileExist localPoseFile) then
		(
			c2PickableNanoObjects = getMAXFileObjectNames localPoseFile quiet:true
			
			if response == #yes then
			(
				loadMaxFile localPoseFile quiet:true
			)
			else if response == #no then
			(
				c2PickableOrigObjects = objects as array
				mergeMaxFile localPoseFile #skipDups #useSceneMtlDups quiet:true
			)
		) else (
			print ("FILE DOES NOT EXIST: " + localPoseFile)
		)
	)

	fn fnC2MakePickDummies type =
	(
		if (selection.count != 1) then
		(
			messageBox("You must select only the pickable mesh object.")
			return()
		)
		if (superclassof selection[1] != GeometryClass) then
		(
			messageBox("You must select only the pickable mesh object.")
			return()
		)
		
		pickObj = selection[1]
		exportNode = pickObj
		if (isValidNode pickObj.parent) then
			exportNode = pickObj.parent
		
		pickChilds = pickObj.children
		for child in pickChilds do
		(
			if (classOf child == Dummy) then
			(
				if (matchPattern child.name pattern:"player_grab*" ignoreCase:true) == true then
				(
					delete child
				)
			)
		)
		
		rHand = $'_Bip01 weapon_bone'
		if (isValidNode rHand) == false then
		(
			messageBox("Cannot find _Bip01 weapon_bone!")
			return()
		)
		
		rHandPos = biped.getTransform rHand #pos
		rHandRot = biped.getTransform rHand #rotation
		dummy1 = Dummy pos:[0,0,0] isSelected:off
		dummy1.rotation = inverse rHandRot
		dummy1.position = rHandPos
		if (type == "1H") then
			dummy1.name = "player_grab_1h"
		if (type == "pole") then
			dummy1.name = "player_grab_pole"
		if (type == "2H") then
			dummy1.name = "player_grab"
		dummy1.parent = pickObj
		pickObj.position = [0,0,0]
		pickObj.rotation = (EulerAngles 0 0 0)
		
		UtilityPanel.OpenUtility csExport
		csexport.export.set_node_list(#())
		csexport.export.set_node_list(#(exportNode))
			
		select dummy1
	)

	fn fnC2SetPickablePose =
	(
		if (selection.count != 1) then
		(
			messageBox("You must select the pickable helper node.")
			return()
		)
		if (classOf selection[1] != Dummy) then
		(
			messageBox("You must select the pickable helper node.")
			return()
		)
		
		pickHelper = selection[1]
		pickObj = pickHelper.parent
		pickParent = pickObj.parent
		
		rHand = $'_Bip01 weapon_bone'
		
		dumTrans = pickHelper.transform
		dummy1 = Dummy pos:[0,0,0] isSelected:off
		dummy1.transform = dumTrans
		pickObj.parent = dummy1

		rHandPos = rHand.objecttransform.position
		rHandRot = rHand.objecttransform.rotation
		dummy1.rotation = inverse rHandRot
		dummy1.position = rHandPos
		if (pickParent != undefined) then
			pickObj.parent = pickParent
		delete dummy1
		select pickHelper
	)

	fn fnC2ResetPickablePos = 
	(
		if (selection.count != 1) then
		(
			messageBox("You must select the pickable helper node.")
			return()
		)
		if (classOf selection[1] != Dummy) then
		(
			messageBox("You must select the pickable helper node.")
			return()
		)

		pickHelper = selection[1]
		pickObj = pickHelper.parent
		
		pickObj.position = [0,0,0]
		pickObj.rotation = (EulerAngles 0 0 0)
	)






	
	on btn_c2Open2HPose pressed do
	(
		fnC2GetPickPose "2H"
	)
	on btn_c2Make2HDummies pressed do
	(
		fnC2MakePickDummies "2H"
	)
	
	on btn_c2Open1HPose pressed do
	(
		fnC2GetPickPose "1H"
	)
	on btn_c2Make1HDummies pressed do
	(
		fnC2MakePickDummies "1H"
	)
	
	on btn_c2Open1HPolePose pressed do
	(
		fnC2GetPickPose "pole"
	)
	on btn_c2Make1HPoleDummies pressed do
	(
		fnC2MakePickDummies "pole"
	)
	on btn_c2Set1pCam pressed do
	(
		if isValidNode $_camera_head then
		(
			origViewTM = getViewTM()
			viewport.setCamera $_camera_head
		)
	)
	on btn_c2SetPerspCam pressed do
	(
		viewport.setType #view_persp_user
		viewport.setTM origViewTM
	)
	on btn_c2PreviewPos pressed do
	(
		fnC2SetPickablePose()
	)
	on btn_c2ResetPos pressed do
	(
		fnC2ResetPickablePos()
	)
	on btn_c2CleanupPickableScene pressed do
	(
		cleanArray = c2PickableNanoObjects
		objCollection = #()
		print ("Original objects = ")
		print c2PickableOrigObjects
		
		for objName in c2PickableNanoObjects do
		(
			obj = getNodeByName objName
			if (findItem c2PickableOrigObjects obj) == 0 then
			(
				print ("Deleting: " + objName)
				append objCollection obj
			) else
				print ("** NOT deleting " + objName)
		)
		try(delete objCollection) catch()
	)
)

try(removeSubrollout (cryMaxTools.basic.ROMan.get "rltCryMaxToolBox").rltToolHolder (cryMaxTools.basic.ROMan.get "rltCryPickableSetup_rollout")) catch()
try(cryMaxTools.basic.ROMan.cryAdd "rltCryPickableSetup_rollout" rltCryPickableSetup_rollout #main) catch()
try(addSubrollout (cryMaxTools.basic.ROMan.get "rltCryMaxToolBox").rltToolHolder (cryMaxTools.basic.ROMan.get "rltCryPickableSetup_rollout")) catch()
	