unit fMain;

interface

uses
  System.Json,
  System.SysUtils,
  System.IOUtils,

  System.Types,
  System.UITypes,
  System.Classes,

  System.Variants,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,

  System.Math.Vectors,
  FMX.Controls3D,
  FMX.Layers3D,
  FMX.Viewport3D,

  FMX.StdCtrls,
  FMX.Controls.Presentation,
  System.Math,
  FMX.Layouts,

  FMX.Objects3D,
  FMX.MaterialSources,
  FMX.Types3D,
  FMX.Ani,
  Data.Bind.EngExt,

  FMX.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,

  Data.Bind.Components,
  uDebug,
  FMX.ScrollBox,
  FMX.Memo,
  uGraphiques;

type
  TfrmMain = class(TForm)
    ToolBar1: TToolBar;
    btnResetPosition: TButton;
    Viewport3D1: TViewport3D;
    Image3DEtage2: TPlane;
    Camera1: TCamera;
    DummyPourAnimation: TDummy;
    LumiereGarage1: TSphere;
    LightMaterialSourceEtage2: TLightMaterialSource;
    Image3DEtage1: TPlane;
    LumiereEt1Couloir1: TSphere;
    LightMaterialSourceEtage1: TLightMaterialSource;
    LightMaterialSourceEtage0: TLightMaterialSource;
    Image3DEtage0: TPlane;
    LumiereEt2Couloir1: TSphere;
    LightMaterialSourceLightOff: TLightMaterialSource;
    LightMaterialSourceLightOn: TLightMaterialSource;
    FloatAnimationVue1Etage: TFloatAnimation;
    DummyPourVisu: TDummy;
    Rect3DPorteGarage: TCube;
    LightMaterialSourceVolet: TLightMaterialSource;
    FloatAnimationRetour3D: TFloatAnimation;
    Rect3DPortail: TCube;
    LightMaterialSourcePortail: TLightMaterialSource;
    LumiereEt2Couloir2: TSphere;
    LumiereChambreBastien: TSphere;
    LumiereChambreBlanche: TSphere;
    LumiereEt2EscalierHaut: TSphere;
    LumiereEt2WC: TSphere;
    LumiereSdB: TSphere;
    LumiereSdBBuanderie: TSphere;
    LumiereSdBMirroir: TSphere;
    LumiereChambreNous: TSphere;
    LumiereBibliotheque: TSphere;
    LumiereSalon: TSphere;
    LumiereEt1Couloir2: TSphere;
    LumiereEt1Couloir3: TSphere;
    LumierePlacard: TSphere;
    LumiereEscalierEt1Haut: TSphere;
    LumiereHalogene: TSphere;
    LumiereVersEscalier: TSphere;
    LumiereTerrasse: TSphere;
    LumiereSalleAManger: TSphere;
    LumiereCuisine: TSphere;
    LumierePlanTravail: TSphere;
    LumiereSdE: TSphere;
    LumiereBureau: TSphere;
    LumiereEt1WC: TSphere;
    LumiereGarage3: TSphere;
    LumiereGarage2: TSphere;
    LumiereChambreJardin: TSphere;
    LumiereVestiaire: TSphere;
    LumiereCave: TSphere;
    LumiereEvier: TSphere;
    LumiereEt0Couloir: TSphere;
    LumiereEt0Escalier: TSphere;
    Light4: TLight;
    Light1: TLight;
    Light5: TLight;
    Light6: TLight;
    Light7: TLight;
    Light8: TLight;
    Light9: TLight;
    Light10: TLight;
    Light11: TLight;
    Light12: TLight;
    Light13: TLight;
    Light14: TLight;
    Light15: TLight;
    Light16: TLight;
    Light17: TLight;
    Light18: TLight;
    Light19: TLight;
    Light20: TLight;
    Light21: TLight;
    Light22: TLight;
    Light23: TLight;
    Light24: TLight;
    Light25: TLight;
    Light26: TLight;
    Light27: TLight;
    Light28: TLight;
    Light2: TLight;
    Light3: TLight;
    Light29: TLight;
    Light30: TLight;
    Light31: TLight;
    Light32: TLight;
    Light33: TLight;
    Light34: TLight;
    Light35: TLight;
    LightMaterialSourceHalo: TLightMaterialSource;
    Sphere1: TSphere;
    LightGlobale: TLight;
    Sphere2: TSphere;
    Sphere3: TSphere;
    Sphere4: TSphere;
    Sphere5: TSphere;
    Sphere6: TSphere;
    Sphere7: TSphere;
    Sphere8: TSphere;
    Sphere9: TSphere;
    Sphere10: TSphere;
    Sphere11: TSphere;
    Sphere12: TSphere;
    Sphere13: TSphere;
    Sphere14: TSphere;
    Sphere15: TSphere;
    Sphere16: TSphere;
    Sphere17: TSphere;
    Sphere18: TSphere;
    Sphere19: TSphere;
    Sphere20: TSphere;
    Sphere21: TSphere;
    Sphere22: TSphere;
    Sphere23: TSphere;
    Sphere24: TSphere;
    Sphere25: TSphere;
    Sphere26: TSphere;
    Sphere27: TSphere;
    Sphere28: TSphere;
    Sphere29: TSphere;
    Sphere30: TSphere;
    Sphere31: TSphere;
    Sphere32: TSphere;
    Sphere33: TSphere;
    Sphere34: TSphere;
    Sphere35: TSphere;
    LumiereCourExterieure: TSphere;
    Light36: TLight;
    Sphere37: TSphere;
    VoletSalleAManger: TCube;
    VoletSalon: TCube;
    VoletSde: TCube;
    VoletCuisine: TCube;
    VoletBureau3: TCube;
    VoletBureau2: TCube;
    VoletBureau1: TCube;
    VoletSdB1: TCube;
    VoletSdB2: TCube;
    VoletChambreSud1: TCube;
    VoletChambreSud2: TCube;
    VoletChambreNous1: TCube;
    VoletChambreNous2: TCube;
    VoletSdb4: TCube;
    VoletChambreBastien2: TCube;
    VoletBibliotheque: TCube;
    VoletTerrasse1: TCube;
    VoletTerrasse2: TCube;
    VoletTerrasse3: TCube;
    VoletTerrasse4: TCube;
    VoletTerrasse5: TCube;
    VoletTerrasse6: TCube;
    brnRefresh: TButton;
    StoreTerrasse: TCube;
    DummyCameraXonValueZ: TDummy;
    ArcDial2: TArcDial;
    ArcDialAngleZ: TArcDial;
    DummyCameraZonValueX: TDummy;
    Layer3DDebug: TLayer3D;
    FrameDebug3D1: TFrameDebug3D;
    btn3DInfos: TButton;
    FloatAnimationGoToDebug: TFloatAnimation;
    ArcDialAngleX: TArcDial;
    Layer3DGraphTemperature: TLayer3D;
    DummyDebug: TDummy;
    FrameGraphiques3DTemperature: TFrameGraphiques3D;
    FloatAnimationBasculeGraphVersInformation: TFloatAnimation;
    BindingsList1: TBindingsList;
    LinkControlToPropertyRotationAngleZ: TLinkControlToProperty;
    LinkControlToPropertyRotationAngleX: TLinkControlToProperty;
    Layer3DDataGraph: TLayer3D;
    FrameDebug3D2: TFrameDebug3D;
    FloatAnimationBasculeDebugMemo: TFloatAnimation;
    ChauffageVestiaire: TCube;
    LightMaterialSourceRadiateur: TLightMaterialSource;
    ChauffageBureau: TCube;
    ChauffageSdE: TCube;
    LightMaterialSourceChauffageEco: TLightMaterialSource;
    LightMaterialSourceChauffageHorsGel: TLightMaterialSource;
    LightMaterialSourceChauffageNormal: TLightMaterialSource;
    LightMaterialSourceChauffageArret: TLightMaterialSource;
    ChauffageSdB: TCube;
    ChauffageChambreNord: TCube;
    ChauffageChambreSud: TCube;
    ChauffageChambreEst: TCube;
    LightMaterialSourceStore: TLightMaterialSource;
    LightMaterialSourceVoletOuvert: TLightMaterialSource;
    LightMaterialSourceVoletFermé: TLightMaterialSource;
    LightMaterialSourceCour: TLightMaterialSource;
    CubeCour: TCube;
    FloatAnimationBasculeGraph: TFloatAnimation;
    Layer3DGraphLinky: TLayer3D;
    FrameGraphiques3DLinky: TFrameGraphiques3D;
    FloatAnimationGraphLinkyVersMemo: TFloatAnimation;
    VoletChambreBastien1Cube: TCube;
    LightMaterialSourceVoletEnCours: TLightMaterialSource;
    Timer1: TTimer;
    LinkControlToPropertyPositionY: TLinkControlToProperty;
    procedure FormCreate(Sender: TObject);
    procedure btnResetPositionClick(Sender: TObject);
    procedure Image3DEtage2Click(Sender: TObject);
    procedure FloatAnimationVue1EtageProcess(Sender: TObject);
    procedure FloatAnimationVue1EtageFinish(Sender: TObject);
    procedure FloatAnimationRetour3DProcess(Sender: TObject);
    procedure FloatAnimationRetour3DFinish(Sender: TObject);
    procedure LumiereClick(Sender: TObject);
    procedure Image3DEtage1DblClick(Sender: TObject);
    procedure VoletClick(Sender: TObject);
    procedure brnRefreshClick(Sender: TObject);
    procedure btn3DInfosClick(Sender: TObject);
    procedure FloatAnimationGoToDebugProcess(Sender: TObject);
    procedure FloatAnimationGoToDebugFinish(Sender: TObject);
    procedure TFrameGraphiques3D1btnGoToMemoClick(Sender: TObject);
    procedure FrameDebug3D1btnSwitchGraphClick(Sender: TObject);
    procedure FrameDebug3D2btnSwitchRightClick(Sender: TObject);
    procedure FrameDebug3D2btnSwitchGraphClick(Sender: TObject);
    procedure TFrameGraphiques3D1Button1Click(Sender: TObject);
    procedure FrameGraphiques3DTemperaturebtnSwitchGraphClick(Sender: TObject);
    procedure FrameGraphiques3DLinkybtnGoToMemoClick(Sender: TObject);
    procedure FrameGraphiques3DLinkybtnSwitchGraphClick(Sender: TObject);
    procedure FrameDebug3D1btnSwitchRightClick(Sender: TObject);
  private
    // DistanceCamera: Double;
    AngleCameraZMemoire: Double;
    AngleCameraXMemoire: Double;
    DistanceCameraMemoire: Double;
    DistanceCameraMemoireTop: Double;
    AngleCameraXMemoireTop: Double;
    AngleCameraZMemoireTop: Double;
    AngleCameraZTarget: Double;
    AngleCameraXTarget: Double;
    { Déclarations privées }
  public
    { Déclarations publiques }
    VersionOffline: Boolean; // ne fait pas appel à http, fonctionne en simulation
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}


uses
  DMRest,
  System.RegularExpressions;

procedure TfrmMain.brnRefreshClick(Sender: TObject);
begin
  DataModuleRest.RESTRequestEtat.Params.Items[0].Value := '111';
  DataModuleRest.RESTRequestEtat.Execute;
end;

procedure TfrmMain.btn3DInfosClick(Sender: TObject);
begin
  if not FloatAnimationGoToDebug.Inverse then
    begin
      AngleCameraZMemoire := ArcDialAngleZ.Value;
      AngleCameraXMemoire := ArcDialAngleX.Value;
      DistanceCameraMemoire := Camera1.Position.Y;
    end;
  AngleCameraZTarget := -90;
  AngleCameraXTarget := 90;
  ArcDialAngleX.Visible := FloatAnimationGoToDebug.Inverse;
  ArcDialAngleZ.Visible := FloatAnimationGoToDebug.Inverse;
  ArcDial2.Visible := FloatAnimationGoToDebug.Inverse;
  FloatAnimationGoToDebug.Start;

end;

procedure TfrmMain.btnResetPositionClick(Sender: TObject);
begin
  DummyDebug.Visible := False;
  Image3DEtage0.Visible := True;
  Image3DEtage2.Visible := True;
  Image3DEtage1.Visible := True;
  Image3DEtage0.opacity := 1;
  Image3DEtage2.opacity := 1;
  Image3DEtage1.opacity := 1;

  DummyPourVisu.Position.X := 0;
  DummyPourVisu.Position.Y := 0;
  DummyPourVisu.Position.Z := 0;

  ArcDialAngleZ.Value := -8;
  DummyCameraZonValueX.RotationAngle.X := ArcDialAngleZ.Value;
  ArcDialAngleX.Value := 25;
  DummyCameraXonValueZ.RotationAngle.Z := ArcDialAngleX.Value;
  Camera1.Position.Y := 90;
  Camera1.ResetRotationAngle;
  Camera1.RotationAngle.X := 0;
  Camera1.RotationAngle.Y := 0;
  Camera1.RotationAngle.Z := 0;

  LightGlobale.Enabled := True;
  LightMaterialSourceEtage0.Diffuse := TAlphaColorRec.Black;
  LightMaterialSourceEtage1.Diffuse := TAlphaColorRec.Black;
  LightMaterialSourceEtage2.Diffuse := TAlphaColorRec.Black;
  DataModuleRest.VueIndividuelle := False;
  DataModuleRest.SetLumiereActive;
end;

procedure TfrmMain.FloatAnimationVue1EtageFinish(Sender: TObject);
begin
  Image3DEtage0.Visible := False;
  Image3DEtage2.Visible := False;
  Image3DEtage1.Visible := False;

  TImage3D(DataModuleRest.EtageEnCours).Visible := True;
end;

procedure TfrmMain.FloatAnimationVue1EtageProcess(Sender: TObject);
var
  i: Single;
begin
  i := DummyPourAnimation.RotationAngle.X;
  // on utilise la rotation d'un dummy comme valeur d'animation
  // on positionne la caméra sur une sphere

  ArcDialAngleZ.Value := AngleCameraZMemoire - AngleCameraZMemoire * i / 100 + AngleCameraZTarget * i / 100; // doit atteindre -90;
  DummyCameraZonValueX.RotationAngle.X := ArcDialAngleZ.Value;
  // doit atteindre 0;
  ArcDialAngleX.Value := AngleCameraXMemoire - AngleCameraXMemoire * i / 100 + AngleCameraXTarget * i / 100; // doit atteindre 90;
  DummyCameraXonValueZ.RotationAngle.Z := ArcDialAngleX.Value;
  Camera1.Position.Y := DistanceCameraMemoire - DistanceCameraMemoire * i / 100 + 50 * i / 100; // doit atteindre 50;

  if DataModuleRest.EtageEnCours <> Image3DEtage0 then
    Image3DEtage0.opacity := 1 - (i - 20) / 80;
  if DataModuleRest.EtageEnCours <> Image3DEtage2 then
    Image3DEtage2.opacity := 1 - (i - 20) / 80;
  if DataModuleRest.EtageEnCours <> Image3DEtage1 then
    Image3DEtage1.opacity := 1 - (i - 20) / 80;

  Image3DEtage0.Visible := Image3DEtage0.opacity > 0;
  Image3DEtage1.Visible := Image3DEtage1.opacity > 0;
  Image3DEtage2.Visible := Image3DEtage2.opacity > 0;

end;

procedure TfrmMain.FloatAnimationGoToDebugFinish(Sender: TObject);
begin
  FloatAnimationGoToDebug.Inverse := not FloatAnimationGoToDebug.Inverse;
end;

procedure TfrmMain.FloatAnimationGoToDebugProcess(Sender: TObject);
var
  i: Single;
begin
  i := DummyCameraXonValueZ.Position.X;
  // on utilise la Position d'un dummy comme valeur d'animation
  // on positionne la caméra sur une sphere

  ArcDialAngleZ.Value := AngleCameraZMemoire - AngleCameraZMemoire * i / FloatAnimationGoToDebug.StopValue + 0 * i / FloatAnimationGoToDebug.StopValue; // doit atteindre 0
  DummyCameraZonValueX.RotationAngle.X := ArcDialAngleZ.Value;
  ArcDialAngleX.Value := AngleCameraXMemoire - AngleCameraXMemoire * i / FloatAnimationGoToDebug.StopValue + 90 * i / FloatAnimationGoToDebug.StopValue; // doit atteindre 90
  DummyCameraXonValueZ.RotationAngle.Z := ArcDialAngleX.Value;
  Camera1.Position.Y := DistanceCameraMemoire - DistanceCameraMemoire * i / FloatAnimationGoToDebug.StopValue + 33 * i / FloatAnimationGoToDebug.StopValue; // doit atteindre 50;

  Image3DEtage0.opacity := 1 - (i - 4) / (FloatAnimationGoToDebug.StopValue - 4);
  Image3DEtage2.opacity := 1 - (i - 4) / (FloatAnimationGoToDebug.StopValue - 4);
  Image3DEtage1.opacity := 1 - (i - 4) / (FloatAnimationGoToDebug.StopValue - 4);

  DummyDebug.opacity := (i - 4) / (FloatAnimationGoToDebug.StopValue - 4);

  DummyDebug.Visible := DummyDebug.opacity > 0;

  Image3DEtage0.Visible := Image3DEtage0.opacity > 0;
  Image3DEtage1.Visible := Image3DEtage1.opacity > 0;
  Image3DEtage2.Visible := Image3DEtage2.opacity > 0;

end;

procedure TfrmMain.FloatAnimationRetour3DFinish(Sender: TObject);
begin
  DataModuleRest.VueIndividuelle := False;
  LightGlobale.Enabled := True;
  LightMaterialSourceEtage0.Diffuse := TAlphaColorRec.Black;
  LightMaterialSourceEtage1.Diffuse := TAlphaColorRec.Black;
  LightMaterialSourceEtage2.Diffuse := TAlphaColorRec.Black;
  DataModuleRest.SetLumiereActive;
  ArcDialAngleZ.Value := AngleCameraZMemoire;
  DummyCameraZonValueX.RotationAngle.X := ArcDialAngleZ.Value;
  ArcDialAngleX.Value := AngleCameraXMemoire;
  DummyCameraXonValueZ.RotationAngle.Z := ArcDialAngleX.Value;
  Camera1.Position.Y := DistanceCameraMemoire;

end;

procedure TfrmMain.FloatAnimationRetour3DProcess(Sender: TObject);
var
  i: Single;
begin
  i := DummyPourAnimation.RotationAngle.Y;

  if DataModuleRest.EtageEnCours <> Image3DEtage0 then
    Image3DEtage0.opacity := (i - 20) / 80;
  if DataModuleRest.EtageEnCours <> Image3DEtage2 then
    Image3DEtage2.opacity := (i - 20) / 80;
  if DataModuleRest.EtageEnCours <> Image3DEtage1 then
    Image3DEtage1.opacity := (i - 20) / 80;

  Image3DEtage0.Visible := Image3DEtage0.opacity > 0;
  Image3DEtage1.Visible := Image3DEtage1.opacity > 0;
  Image3DEtage2.Visible := Image3DEtage2.opacity > 0;

  ArcDialAngleZ.Value := AngleCameraZMemoireTop - AngleCameraZMemoireTop * i / 100 + AngleCameraZMemoire * i / 100; // doit atteindre AngleCameraZMemoire ;
  DummyCameraZonValueX.RotationAngle.X := ArcDialAngleZ.Value;
  ArcDialAngleX.Value := AngleCameraXMemoireTop - AngleCameraXMemoireTop * i / 100 + AngleCameraXMemoire * i / 100; // doit atteindre AngleCameraXMemoire ;
  DummyCameraXonValueZ.RotationAngle.Z := ArcDialAngleX.Value;
  Camera1.Position.Y := DistanceCameraMemoireTop - DistanceCameraMemoireTop * i / 100 + DistanceCameraMemoire * i / 100; // doit atteindre 50;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  VersionOffline := True;
  btnResetPositionClick(Sender);
end;

procedure TfrmMain.FrameDebug3D1btnSwitchGraphClick(Sender: TObject);
begin
  FloatAnimationBasculeDebugMemo.Inverse := True;
  FloatAnimationBasculeDebugMemo.Start;
end;

procedure TfrmMain.FrameDebug3D1btnSwitchRightClick(Sender: TObject);
begin
  FloatAnimationGraphLinkyVersMemo.Inverse := True;
  FloatAnimationGraphLinkyVersMemo.Start;
end;

procedure TfrmMain.FrameDebug3D2btnSwitchGraphClick(Sender: TObject);
begin
  FloatAnimationBasculeGraphVersInformation.Inverse := True;
  FloatAnimationBasculeGraphVersInformation.Start;
end;

procedure TfrmMain.FrameDebug3D2btnSwitchRightClick(Sender: TObject);
begin
  FloatAnimationBasculeDebugMemo.Inverse := False;
  FloatAnimationBasculeDebugMemo.Start;
end;

procedure TfrmMain.FrameGraphiques3DLinkybtnGoToMemoClick(Sender: TObject);
begin
  FloatAnimationBasculeGraph.Inverse := True;
  FloatAnimationBasculeGraph.Start;

end;

procedure TfrmMain.FrameGraphiques3DLinkybtnSwitchGraphClick(Sender: TObject);
begin
  FloatAnimationGraphLinkyVersMemo.Inverse := False;
  FloatAnimationGraphLinkyVersMemo.Start;
end;

procedure TfrmMain.FrameGraphiques3DTemperaturebtnSwitchGraphClick(Sender: TObject);
begin
  FloatAnimationBasculeGraph.Inverse := False;
  FloatAnimationBasculeGraph.Start;
end;

procedure TfrmMain.Image3DEtage1DblClick(Sender: TObject);
begin
  Image3DEtage2.Visible := not Image3DEtage2.Visible;
end;

procedure TfrmMain.Image3DEtage2Click(Sender: TObject);

begin
  if (Image3DEtage0.opacity > 0) and (Image3DEtage2.opacity > 0) and (Image3DEtage1.opacity > 0) then
    begin
      // zoom sur un étage

      AngleCameraZMemoire := ArcDialAngleZ.Value;
      AngleCameraXMemoire := ArcDialAngleX.Value;
      DistanceCameraMemoire := Camera1.Position.Y;
      DataModuleRest.EtageEnCours := Sender;
      AngleCameraZTarget := -90;
      AngleCameraXTarget := 90;
      LightGlobale.Enabled := False;
      LightMaterialSourceEtage0.Diffuse := TAlphaColorRec.White;
      LightMaterialSourceEtage1.Diffuse := TAlphaColorRec.White;
      LightMaterialSourceEtage2.Diffuse := TAlphaColorRec.White;
      DataModuleRest.VueIndividuelle := True;
      DataModuleRest.SetLumiereActive;
      FloatAnimationVue1Etage.Start;
      // for i := 1 to 100 do
      // begin
      //
      // ArcDialAngleZ.Value := AngleCameraZMemoire - AngleCameraZMemoire * i / 100; // doit atteindre 0;
      // DummyCameraZonValueX.RotationAngle.Y := AngleCameraXMemoire - AngleCameraZMemoire * i / 100 + 90 * i / 100; // doit atteindre 90;
      // DistanceCamera := DistanceCameraMemoire - DistanceCameraMemoire * i / 100 + 50 * i / 100; // doit atteindre 50;
      // CalculCoordCartesienne;
      // Camera1.RotationAngle.X := RotationAngleXMemoire - RotationAngleXMemoire * i / 100 + 90 * i / 100; // doit atteindre 90;
      // Camera1.RotationAngle.Y := RotationAngleYMemoire - RotationAngleYMemoire * i / 100; // doit atteindre 0;
      // Camera1.RotationAngle.Z := RotationAngleZMemoire - RotationAngleZMemoire * i / 100 + 90 * i / 100; // doit atteindre 90;
      //
      // if Sender <> Image3DEtage0 then
      // Image3DEtage0.opacity := 1 - i / 80;
      // if Sender <> Image3DEtage2 then
      // Image3DEtage2.opacity := 1 - i / 80;
      //
      // if Sender <> Image3DEtage1 then
      // Image3DEtage1.opacity := 1 - i / 80;
      //
      // sleep(10);
      // Application.ProcessMessages;
      //
      // end;
      // Image3DEtage0.Visible := False;
      // Image3DEtage2.Visible := False;
      // Image3DEtage1.Visible := False;
      //
      // TImage3D(Sender).Visible := True;

    end
  else
    begin
      Image3DEtage0.Visible := True;
      Image3DEtage2.Visible := True;
      Image3DEtage1.Visible := True;

      AngleCameraZMemoireTop := ArcDialAngleZ.Value;
      AngleCameraXMemoireTop := ArcDialAngleX.Value;
      DistanceCameraMemoireTop := Camera1.Position.Y;

      AngleCameraZTarget := AngleCameraZMemoire;
      AngleCameraXTarget := AngleCameraXMemoire;

      FloatAnimationRetour3D.Start;
      // FloatAnimationRetour3DFinish
    end;
end;

procedure TfrmMain.LumiereClick(Sender: TObject);
begin
  if Sender is TSphere then
    begin
      if VersionOffline then
        begin
          if TSphere(Sender).tag = 0 then
            TSphere(Sender).tag := 1
          else
            TSphere(Sender).tag := 0;

          // Tsphere(Sender).ImageIndex := EtatObjet;
          if TSphere(Sender).ChildrenCount >= 1 then
            begin
              if TSphere(Sender).Children[0] is TLight then
                begin
                  TLight(TSphere(Sender).Children[0]).Enabled := (TSphere(Sender).tag = 0) and DataModuleRest.VueIndividuelle and (TSphere(Sender).Parent = DataModuleRest.EtageEnCours);
                  if TSphere(Sender).tag = 0 then
                    TSphere(Sender).MaterialSource := frmMain.LightMaterialSourceLightOn
                  else
                    TSphere(Sender).MaterialSource := frmMain.LightMaterialSourceLightOff;
                end;
            end;
          if TSphere(Sender).ChildrenCount >= 2 then
            begin
              if TSphere(Sender).Children[1] is TSphere then
                begin
                  TSphere(TSphere(Sender).Children[1]).HitTest := False;
                  TSphere(TSphere(Sender).Children[1]).Visible := (TSphere(Sender).tag = 0) and not DataModuleRest.VueIndividuelle;
                end;
            end;
        end
      else if TSphere(Sender).tag <> 0 then
        begin
          DataModuleRest.RESTRequestEtat.Params.Items[0].Value := TSphere(Sender).tag.ToString;
          DataModuleRest.RESTRequestEtat.ExecuteAsync;
        end;
    end;
end;

procedure TfrmMain.TFrameGraphiques3D1btnGoToMemoClick(Sender: TObject);
begin
  FloatAnimationBasculeGraphVersInformation.Inverse := False;
  FloatAnimationBasculeGraphVersInformation.Start;
end;

procedure TfrmMain.TFrameGraphiques3D1Button1Click(Sender: TObject);
var
  JSONValue: TJSONValue;
  fileName: String;
begin
  if VersionOffline then
    begin
      fileName := TPath.Combine(ExtractFilePath(ParamStr(0)), 'TempJsonSample.json');
      JSONValue := TJSONObject.ParseJSONValue(TFile.ReadAllText(fileName));
      DataModuleRest.jValueArrayGraph := JSONValue as TJSONArray;
      frmMain.FrameDebug3D2.MemoJsonEtat.Text := TRegEx.Replace(DataModuleRest.jValueArrayGraph.ToString, ',', ',' + #13 + #10);
      DataModuleRest.JSONToChartPuissance(DataModuleRest.jValueArrayGraph);

    end
  else
    begin

      DataModuleRest.RESTClientGraph.BaseURL := 'https://[SiteWebOuIPDomotique]/[PageDemandeActionRetourneResultat]';
      DataModuleRest.RESTRequestGraph.ExecuteAsync(
        procedure
        begin
          if DataModuleRest.jValueArrayGraph <> nil then
            begin
              // frmMain.FrameDebug3D2.MemoJsonEtat.Text := TRegEx.Replace(DataModuleRest.jValueArrayGraph.ToString, ',', ',' + #13 + #10);

              try
                // mettre cette action en thread car prend du temps
                DataModuleRest.JSONToChartPuissance(DataModuleRest.jValueArrayGraph);
              finally

              end;
            end;
        end)

      // DataModuleRest.RESTRequestGraph.Execute;
    end;
end;

procedure TfrmMain.VoletClick(Sender: TObject);
begin
  //
  if Sender is TCube then
    begin
      if VersionOffline then
        begin
          if TCube(Sender).MaterialSource = frmMain.LightMaterialSourceVoletOuvert then
            TCube(Sender).MaterialSource := frmMain.LightMaterialSourceVoletEnCours
          else if TCube(Sender).MaterialSource = frmMain.LightMaterialSourceVoletFermé then
            TCube(Sender).MaterialSource := frmMain.LightMaterialSourceVolet
          else if TCube(Sender).MaterialSource = frmMain.LightMaterialSourceVolet then
            TCube(Sender).MaterialSource := frmMain.LightMaterialSourceVoletOuvert
          else if TCube(Sender).MaterialSource = frmMain.LightMaterialSourceVoletEnCours then
            TCube(Sender).MaterialSource := frmMain.LightMaterialSourceVoletFermé;
          TCube(Sender).Repaint;
        end
      else if TCube(Sender).tag <> 0 then
        begin
          DataModuleRest.RESTRequestEtat.Params.Items[0].Value := (TCube(Sender).tag + 9500).ToString;
          DataModuleRest.RESTRequestEtat.ExecuteAsync;
        end;
    end;
end;

end.
