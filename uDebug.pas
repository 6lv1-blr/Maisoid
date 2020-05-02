unit uDebug;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.TabControl,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart;

type
  TFrameDebug3D = class(TFrame)
    ToolBar1: TToolBar;
    MemoJsonEtat: TMemo;
    btnSwitchGraph: TButton;
    btnSwitchRight: TButton;
    btnGoBackPlan: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

end.
