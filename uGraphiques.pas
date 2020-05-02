unit uGraphiques;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMXTee.Engine, FMXTee.Procs, FMXTee.Chart,
  FMXTee.Series;

type
  TFrameGraphiques3D = class(TFrame)
    ToolBar1: TToolBar;
    btnRefreshData: TButton;
    btnGoToMemo: TButton;
    ChartDown: TChart;
    BarSeries1: TFastLineSeries;
    ChartUp: TChart;
    btnSwitchGraph: TButton;
    btnGoBackPlan: TButton;
    Series1: TBarSeries;
    Series2: TBarSeries;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

end.
