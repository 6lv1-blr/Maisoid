unit DMRest;

interface

uses
  System.SysUtils,
  System.Classes,
  REST.Types,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  REST.Client,
  REST.Authenticator.Basic,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  REST.Response.Adapter,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  System.Json,
  System.RegularExpressions,
  System.ImageList, FMX.ImgList;

type
  TDataModuleRest = class(TDataModule)
    RESTClientEtat: TRESTClient;
    RESTRequestEtat: TRESTRequest;
    RESTResponseEtat: TRESTResponse;
    HTTPBasicAuthenticatorEtat: THTTPBasicAuthenticator;
    ImageList1: TImageList;
    RESTRequestGraph: TRESTRequest;
    HTTPBasicAuthenticatorGraph: THTTPBasicAuthenticator;
    RESTResponseGraph: TRESTResponse;
    RESTClientGraph: TRESTClient;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    procedure RESTRequestEtatAfterExecute(Sender: TCustomRESTRequest);
    procedure RESTRequestGraphAfterExecute(Sender: TCustomRESTRequest);
  private
    jValueArray: TJSONArray;
    { Déclarations privées }
  public
    { Déclarations publiques }
    jValueArrayGraph: TJSONArray;
    VueIndividuelle: Boolean;
    EtageEnCours: TObject;
    procedure JSONToChartPuissance(JSonEnvoyé: TJSONArray);
    procedure SetLumiereActive;
  end;

var
  DataModuleRest: TDataModuleRest;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}


uses
  FMX.Dialogs,
  FMX.Objects3D,
  System.Generics.Collections,
  FMX.Types,
  FMX.Controls3D,
  uDebug, fMain, uGraphiques;

{$R *.dfm}


procedure TDataModuleRest.RESTRequestEtatAfterExecute(Sender: TCustomRESTRequest);
begin
  jValueArray := RESTResponseEtat.JSONValue as TJSONArray;
  SetLumiereActive;

end;

procedure TDataModuleRest.RESTRequestGraphAfterExecute(Sender: TCustomRESTRequest);

begin
  if RESTResponseGraph.JSONValue is TJSONArray then
    begin
      jValueArrayGraph := RESTResponseGraph.JSONValue as TJSONArray;
      // if jValueArrayGraph <> nil then
      // begin
      // frmMain.FrameDebug3D2.MemoJsonEtat.Text := TRegEx.Replace(jValueArrayGraph.ToString, ',', ',' + #13 + #10);
      //
      // try
      // JSONToChartPuissance(jValueArrayGraph);
      // finally
      //
      // end;
      // end;
    end;

end;

procedure TDataModuleRest.JSONToChartPuissance(JSonEnvoyé: TJSONArray);

Var
  zLJSONArray, zLJSONArrayDate: TJSONArray;
  zLJSONArrayValue: TJSONArray;
  zI: Integer;
begin
  frmMain.FrameGraphiques3DTemperature.BarSeries1.Clear;
  frmMain.FrameGraphiques3DTemperature.Series1.Clear;
  frmMain.FrameGraphiques3DTemperature.Series2.Clear;
  frmMain.FrameGraphiques3DLinky.BarSeries1.Clear;
  frmMain.FrameGraphiques3DLinky.Series1.Clear;
  frmMain.FrameGraphiques3DLinky.Series2.Clear;

  // ListCapteurCourbe = [
  // 0['Ext',2,'red'],
  if (JSonEnvoyé.Get(0) is TJSONArray) then
    begin
      zLJSONArray := JSonEnvoyé.Get(0) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DTemperature.BarSeries1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                  // frmMain.FrameGraphiques3D.BarSeries1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                  // frmMain.FrameGraphiques3D.Series1.AddXY(((zLJSONArray2.Get(zI)) as TJSONNumber).AsInt64 / 1000 / 86400 + 25569, ((zLJSONArray3.Get(zi)) as TJSONNumber).AsInt64);
                end;
            end;
        end;
    end;
  // 1['Garage',1,'blue'],
  // 2['Salon',13,'green'],
  // 3['Bureau',14,'red'],
  // 4['Sde',15,'blue'],
  // 5['Elec',11,'green'],
  // 6['Bastien',21,'blue'],
  // 7['Nous',22,'green'],
  // 8['Bnb',23,'red'],
  // 9['Pression',12,'red']
  if (JSonEnvoyé.Get(9) is TJSONArray) then
    begin
      zLJSONArray := JSonEnvoyé.Get(9) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DTemperature.Series1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                  // frmMain.FrameGraphiques3D.BarSeries1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                  // frmMain.FrameGraphiques3D.Series1.AddXY(((zLJSONArray2.Get(zI)) as TJSONNumber).AsInt64 / 1000 / 86400 + 25569, ((zLJSONArray3.Get(zi)) as TJSONNumber).AsInt64);
                end;
            end;
        end;
    end;

  //
  // ListCompteurCourbe = [
  // 12['HC..','PAPP','Blue'],
  if (JSonEnvoyé.Get(10) is TJSONArray) then
    begin

      zLJSONArray := JSonEnvoyé.Get(10) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DLinky.Series1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                end;
            end;
        end;
      frmMain.FrameGraphiques3DTemperature.ChartUp.LeftAxis.AutomaticMinimum := false;
      try
        frmMain.FrameGraphiques3DTemperature.ChartUp.LeftAxis.Maximum := 900;
        frmMain.FrameGraphiques3DTemperature.ChartUp.LeftAxis.Minimum := 900;
      finally

      end;
    end;
  // 13['HP..','PAPP','Red'],
  if (JSonEnvoyé.Get(11) is TJSONArray) then
    begin
      zLJSONArray := JSonEnvoyé.Get(11) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DLinky.Series2.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                end;
            end;
        end;
    end;
  // 16['HC..','CONSO','Green'],
  if (JSonEnvoyé.Get(16) is TJSONArray) then
    begin
      zLJSONArray := JSonEnvoyé.Get(16) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DLinky.BarSeries1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                end;
            end;
        end;
    end;
  // 17['HP..','CONSO','Yellow']
  if (JSonEnvoyé.Get(17) is TJSONArray) then
    begin
      zLJSONArray := JSonEnvoyé.Get(17) as TJSONArray;
      if (zLJSONArray.Get(0) is TJSONArray) then
        begin
          zLJSONArrayDate := zLJSONArray.Get(0) as TJSONArray;
          zLJSONArrayValue := zLJSONArray.Get(1) as TJSONArray;
          for zI := 0 to zLJSONArrayDate.Size - 1 do
            begin
              if (zLJSONArrayDate.Get(zI) is TJSONNumber) then
                begin
                  frmMain.FrameGraphiques3DLinky.BarSeries1.AddXY(((zLJSONArrayDate.Get(zI)) as TJSONNumber).AsInt64 / 86400 + 25569, ((zLJSONArrayValue.Get(zI)) as TJSONNumber).AsDouble);
                end;
            end;
        end;
    end;

end;

procedure TDataModuleRest.SetLumiereActive;
var
  j: Integer;
  EtatObjet: Integer; // 1 Eteint 2 Allumé
  i: Integer;
  TempString: string;
begin

  if jValueArray <> nil then
    begin
      frmMain.FrameDebug3D1.MemoJsonEtat.Text := TRegEx.Replace(jValueArray.ToString, ',', ',' + #13 + #10);
    end;
  for j := 0 to frmMain.ComponentCount - 1 do
    begin
      // Gestion Etat des Lumières
      if (frmMain.Components[j] is Tsphere) and String(Tsphere(frmMain.Components[j]).Name).StartsWith('Lumiere') then
        begin
          begin
            if frmMain.VersionOffline then
              begin
                if Tsphere(frmMain.Components[j]).tag = 0 then
                  EtatObjet := 2
                else
                  EtatObjet := 1
              end
            else
              begin
                EtatObjet := 1;
                if jValueArray <> nil then
                  begin
                    for i := 0 to jValueArray.Count - 1 do
                      begin
                        if Tsphere(frmMain.Components[j]).tag = strtointdef(jValueArray.Items[i].ToString, -1) then
                          EtatObjet := 2;
                        if Tsphere(frmMain.Components[j]).tag - 500 = strtointdef(jValueArray.Items[i].ToString, -1) then
                          EtatObjet := 2;
                      end;
                  end;
              end;

            if (Tsphere(frmMain.Components[j]).tag <> 0) or frmMain.VersionOffline then
              begin
                // Tsphere(frmMain.Components[j]).ImageIndex := EtatObjet;
                if Tsphere(frmMain.Components[j]).ChildrenCount >= 1 then
                  begin
                    if Tsphere(frmMain.Components[j]).Children[0] is TLight then
                      begin
                        TLight(Tsphere(frmMain.Components[j]).Children[0]).Enabled := (EtatObjet = 2) and VueIndividuelle and (Tsphere(frmMain.Components[j]).Parent = EtageEnCours);
                        if EtatObjet = 2 then
                          Tsphere(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceLightOn
                        else
                          Tsphere(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceLightOff;
                      end;
                  end;
                if Tsphere(frmMain.Components[j]).ChildrenCount >= 2 then
                  begin
                    if Tsphere(frmMain.Components[j]).Children[1] is Tsphere then
                      begin
                        Tsphere(Tsphere(frmMain.Components[j]).Children[1]).HitTest := false;
                        Tsphere(Tsphere(frmMain.Components[j]).Children[1]).Visible := (EtatObjet = 2) and not VueIndividuelle;
                      end;
                  end;
              end;
          end;
        end;
      // Gestion Etat des Volets
      if (frmMain.Components[j] is TCube) and String(TCube(frmMain.Components[j]).Name).StartsWith('Volet') then
        begin
          begin
            EtatObjet := 1;
            if jValueArray <> nil then
              begin
                for i := 0 to jValueArray.Count - 1 do
                  begin
                    if TCube(frmMain.Components[j]).tag + 9000 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 3; // Ouvert
                    if TCube(frmMain.Components[j]).tag + 9100 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 4; // Fermé
                    if TCube(frmMain.Components[j]).tag + 9200 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 2; // En cours de mouvement
                    if TCube(frmMain.Components[j]).tag + 9300 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 1; // stoppé en cours

                  end;
              end;
            if TCube(frmMain.Components[j]).tag <> 0 then
              begin
                case EtatObjet of
                  1: // stoppé en cours
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceVolet;
                  2: // En cours de mouvement
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceVoletEnCours;
                  3: // Ouvert
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceVoletOuvert;
                  4: // Fermé
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceVoletFermé;

                end;
                TCube(frmMain.Components[j]).Repaint;
              end;
          end;
        end;
      // Gestion Etat du store
      if (frmMain.Components[j] is TCube) and String(TCube(frmMain.Components[j]).Name).StartsWith('Store') then
        begin
          begin
            EtatObjet := 1;
            if jValueArray <> nil then
              begin
                for i := 0 to jValueArray.Count - 1 do
                  begin
                    if TCube(frmMain.Components[j]).tag + 9000 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 3; // Ouvert
                    if TCube(frmMain.Components[j]).tag + 9100 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 4; // Fermé
                    if TCube(frmMain.Components[j]).tag + 9200 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 2; // En cours de mouvement
                    if TCube(frmMain.Components[j]).tag + 9300 = strtointdef(jValueArray.Items[i].ToString, -1) then
                      EtatObjet := 1; // stoppé en cours

                  end;
              end;
            if TCube(frmMain.Components[j]).tag <> 0 then
              begin
                case EtatObjet of
                  1: // stoppé en cours
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceStore;
                  2: // En cours de mouvement
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceStore;
                  3: // Ouvert
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceStore;
                  4: // Fermé
                    TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceStore;
                end;
                TCube(frmMain.Components[j]).Repaint;
              end;
          end;
        end;
      // Gestion des Chauffages (Etat pilotées par Agenda Google, pas par l'application, juste visualisation de l'état
      if (frmMain.Components[j] is TCube) and String(TCube(frmMain.Components[j]).Name).StartsWith('Chauffage') then
        begin
          begin
            EtatObjet := 1;
            if jValueArray <> nil then
              begin
                for i := 0 to jValueArray.Count - 1 do
                  begin
                    // EtageJourChauffage
                    // EtageNuitChauffage
                    // EtageSousSolChauffage
                    TempString := TRegEx.Replace(jValueArray.Items[i].ToString, 'ESC', '201');
                    TempString := TRegEx.Replace(TempString, 'EJC', '211');
                    TempString := TRegEx.Replace(TempString, 'ENC', '221');
                    TempString := TRegEx.Replace(TempString, '"', '');

                    if TCube(frmMain.Components[j]).tag / 10 = strtointdef(TempString, -8) div 10 then
                      EtatObjet := strtointdef(TempString, -1) mod 10;
                    case EtatObjet of
                      1:
                        begin
                          TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceChauffageArret;
                        end;
                      2:
                        begin
                          TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceChauffageHorsGel;
                        end;
                      3:
                        begin
                          TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceChauffageEco;
                        end;
                      4:
                        begin
                          TCube(frmMain.Components[j]).MaterialSource := frmMain.LightMaterialSourceChauffageNormal;
                        end;
                    end;
                    TCube(frmMain.Components[j]).Repaint;
                  end;
              end;

          end;
        end;
    end;
end;

end.
