program ecg_synthetic_pr;

uses
  Forms,
  ecg_synthetic in '..\..\PSB\ecg_synthetic.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
