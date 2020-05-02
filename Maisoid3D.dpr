program Maisoid3D;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  DMRest in 'DMRest.pas' {DataModuleRest: TDataModule},
  uDebug in 'uDebug.pas' {FrameDebug3D: TFrame},
  uGraphiques in 'uGraphiques.pas' {FrameGraphiques3D: TFrame};

{$R *.res}


begin
  Application.Initialize;
  Application.CreateForm(TDataModuleRest, DataModuleRest);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
