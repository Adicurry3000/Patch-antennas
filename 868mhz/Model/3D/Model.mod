'# MWS Version: Version 2025.0 - Aug 30 2024 - ACIS 34.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.8 fmax = 0.9
'# created = '[VERSION]2025.0|34.0.1|20240830[/VERSION]


'@ use template: Antenna - Planar.cfg

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2.2", "2.4"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2.4"
Dim sDefineAtName As String
sDefineAtName = "2.4"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ activate local coordinates

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.ActivateWCS "local"

'@ define material: Copper (annealed)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "Copper (annealed)"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .DispersiveFittingSchemeMu "Nth Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .SetMaterialUnit "GHz", "mm"
     .Mu "1.0"
     .Kappa "5.8e+007"
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Component.New "component1"

'@ define material: FR-4 (lossy)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "GHz", "mm"
     .Epsilon "4.3"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.025"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .SetActiveMaterial "all"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ define brick: component1:substrait

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "substrait" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-sl/2", "sl/2" 
     .Yrange "-sw/2", "sw/2" 
     .Zrange "0", "sh" 
     .Create
End With

'@ define brick: component1:GND

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "GND" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-sl/2", "sl/2" 
     .Yrange "-sw/2", "sw/2" 
     .Zrange "-mt", "0" 
     .Create
End With

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:substrait", "1"

'@ align wcs with face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
WCS.AlignWCSWithSelected "Face"

'@ define brick: component1:patch

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "patch" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-pl/2", "pl/2" 
     .Yrange "-pw/2", "pw/2" 
     .Zrange "0", "mt" 
     .Create
End With

'@ define brick: component1:microstrip

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Brick
     .Reset 
     .Name "microstrip" 
     .Component "component1" 
     .Material "Copper (annealed)" 
     .Xrange "-pl/2", "-sl/2" 
     .Yrange "-msw/2", "msw/2" 
     .Zrange "0", "mt" 
     .Create
End With

'@ pick face

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Pick.PickFaceFromId "component1:microstrip", "4"

'@ define port:1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "0", "0"
  .YrangeAdd "1.5*5.74", "1.5*5.74"
  .ZrangeAdd "1.5", "1.5*5.74"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ change solver type

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
ChangeSolverType "HF Time Domain"

'@ define special time domain solver parameters

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
'STEADY STATE
With Solver
     .SteadyStateDurationType "Number of pulses"
     .NumberOfPulseWidths "20"
     .SteadyStateDurationTime "18.3448"
     .SteadyStateDurationTimeAsDistance "5503.45"
     .StopCriteriaShowExcitation "False"
     .RemoveAllStopCriteria
     .AddStopCriterion "All S-Parameters", "0.004", "1", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.004", "1", "False"
     .AddStopCriterion "Reflection S-Parameters", "0.004", "1", "False"
     .AddStopCriterion "All Probes", "0.004", "1", "False"
     .AddStopCriterion "All Radiated Powers", "0.004", "1", "False"
     .AddStopCriterion "All Voltage-Current Monitors", "0.004", "1", "False"
End With

'GENERAL
With Solver
     .TimeStepStabilityFactor "1.0"
     .RestartAfterInstabilityAbort "True"
     .AutomaticTimeSignalSampling "True"
     .SuppressTimeSignalStorage "False"
     .ConsiderExcitationForFreqSamplingRate "False"
     .UseBroadBandPhaseShift "False"
     .SetBroadBandPhaseShiftLowerBoundFac "0.1"
     .SetPortShieldingType "NONE"
     .FrequencySamples "1001"
     .FrequencyLogSamples "0"
     .ConsiderTwoPortReciprocity "True"
     .EnergyBalanceLimit "0.03"
     .TDRComputation "False"
     .TDRShift50Percent "False"
     .AutoDetectIdenticalPorts "False"
End With

'HEXAHEDRAL
With Solver
     .SetPMLType "CONVPML"
     .UseVariablePMLLayerSizeStandard "False"
     .KeepPMLDepthDuringMeshAdaptationWithVariablePMLLayerSize "False"
     .SetSubcycleState "Automatic"
     .NormalizeToReferenceSignal "False"
     .SetEnhancedPMLStabilization "Automatic"
     .SimplifiedPBAMethod "False"
     .SParaAdjustment "True"
     .PrepareFarfields "True"
     .MonitorFarFieldsNearToModel "True"
     .DiscreteItemUpdate "Distributed"
End With

'MATERIAL
With Solver
     .SurfaceImpedanceOrder "10"
     .ActivatePowerLoss1DMonitor "True"
     .PowerLoss1DMonitorPerSolid "False"
     .Use3DFieldMonitorForPowerLoss1DMonitor "True"
     .UseFarFieldMonitorForPowerLoss1DMonitor "False"
     .UseExtraFreqForPowerLoss1DMonitor "False"
     .ResetPowerLoss1DMonitorExtraFreq
     .SetDispNonLinearMaterialMonitor "False"
     .ActivateDispNonLinearMaterialMonitor "0.0",  "0.1",  "0.0",  "False"
     .SetTimePowerLossSIMaterialMonitor "False"
     .ActivateTimePowerLossSIMaterialMonitor "0.0",  "0.1",  "0.0",  "False"
     .SetTimePowerLossSIMaterialMonitorAverage "False"
     .SetTimePowerLossSIMaterialMonitorAverageRepPeriod "0.0"
     .TimePowerLossSIMaterialMonitorPerSolid "False"
     .ActivateSpaceMaterial3DMonitor "False"
     .Use3DFieldMonitorForSpaceMaterial3DMonitor "True"
     .UseExtraFreqForSpaceMaterial3DMonitor "False"
     .ResetSpaceMaterial3DMonitorExtraFreq
     .SetHFTDDispUpdateScheme "Automatic"
End With

'AR-FILTER
With Solver
     .UseArfilter "False"
     .ArMaxEnergyDeviation "0.1"
     .ArPulseSkip "1"
End With

'WAVEGUIDE
With Solver
     .WaveguidePortGeneralized "True"
     .WaveguidePortModeTracking "False"
     .WaveguidePortROM "False"
     .DispEpsFullDeembedding "False"
     .SetSamplesFullDeembedding "20"
     .AbsorbUnconsideredModeFields "Automatic"
     .SetModeFreqFactor "0.5"
     .AdaptivePortMeshing "True"
     .AccuracyAdaptivePortMeshing "1"
     .PassesAdaptivePortMeshing "4"
End With

'HEXAHEDRAL TLM
With Solver
     .AnisotropicSheetSurfaceType "0"
     .MultiStrandedCableRoute "False"
     .UseAbsorbingBoundary "True"
     .UseDoublePrecision "False"
     .AllowMaterialOverlap "True"
     .ExcitePlanewaveNearModel "False"
     .SetGroundPlane "False"
     .GroundPlane "x", "0.0"
     .NumberOfLayers "5"
     .AverageFieldProbe "False"
     .NormalizeToGaussian "True"
     .TimeSignalSamplingFactor "1"
     .SurfaceCurrentOnMesh "False"
     .LossyMetalAsTranslucent "False"
End With

'TLM POSTPROCESSING
With Solver
     .ResetSettings
     .ApplyLinearPrediction "false" 
     .Windowing "None" 
     .LogScaleFrequency "false" 
     .AutoFreqStep "true", "1"
     .SetExcitationSignal "" 
     .SaveSettings
End With

'@ define time domain solver parameters

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "True"
     .AutoNormImpedance "True"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ define excitation signal: signal1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With TimeSignal 
     .Reset 
     .Name "signal1" 
     .SignalType "Gaussian" 
     .ProblemType "High Frequency" 
     .Fmin "800" 
     .Fmax "950" 
     .Create 
End With

'@ define frequency range

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solver.FrequencyRange "0.8", "0.9"

'@ delete excitation signal: signal1

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With TimeSignal 
     .Delete "signal1", "High Frequency" 
End With

'@ define frequency range

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
Solver.FrequencyRange "0.8", "0.9"

'@ farfield plot options

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With FarfieldPlot 
     .Plottype "2DOrtho" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ delete monitor: e-field (f=2.4)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Delete "e-field (f=2.4)" 
End With

'@ define monitor: e-field (f=0.866)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=0.866)" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "0.866" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: farfield (f=2.4)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Delete "farfield (f=2.4)" 
End With

'@ define farfield monitor: farfield (f=0.866)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=0.866)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "0.866" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "Absolute" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ delete monitor: e-field (f=0.866)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Delete "e-field (f=0.866)" 
End With

'@ define monitor: e-field (f=0.868)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=0.868)" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "0.868" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: farfield (f=0.866)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Delete "farfield (f=0.866)" 
End With

'@ define farfield monitor: farfield (f=0.868)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=0.868)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "0.868" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "Absolute" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ delete monitor: h-field (f=2.4)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Delete "h-field (f=2.4)" 
End With

'@ define monitor: h-field (f=0.868)

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=0.868)" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "0.868" 
     .UseSubvolume "False" 
     .Coordinates "Free" 
     .SetSubvolume "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ farfield plot options

'[VERSION]2025.0|34.0.1|20240830[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "0.868" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Realized Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

