unit ecg_synthetic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Buttons, Math,
  Grids;

type
  TForm1 = class(TForm)
    cht_spectral: TChart;
    Series1: TLineSeries;
    grp1: TGroupBox;
    lbledt_f_ecg: TLabeledEdit;
    lbledt_f_int: TLabeledEdit;
    lbledt_N: TLabeledEdit;
    lbledt_A: TLabeledEdit;
    lbledt_h_mean: TLabeledEdit;
    lbledt_h_std: TLabeledEdit;
    lbledt_f_low: TLabeledEdit;
    lbledt_f_high: TLabeledEdit;
    lbledt_c_low: TLabeledEdit;
    lbledt_c_high: TLabeledEdit;
    lbledt_lf_hf_ratio: TLabeledEdit;
    btn_process: TBitBtn;
    btn1: TBitBtn;
    lbledt_sigma_low: TLabeledEdit;
    lbledt_sigma_high: TLabeledEdit;
    cht_spectral1: TChart;
    Series2: TLineSeries;
    btn_processRatio: TBitBtn;
    cht1: TChart;
    Series4: TLineSeries;
    cht2: TChart;
    Series5: TLineSeries;
    Series3: TLineSeries;
    lbledt_scaling: TLabeledEdit;
    lbledt_rr_mean: TLabeledEdit;
    Series6: TLineSeries;
    grp2: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    edt3: TEdit;
    edt4: TEdit;
    edt5: TEdit;
    edt6: TEdit;
    edt7: TEdit;
    edt8: TEdit;
    edt9: TEdit;
    edt10: TEdit;
    edt11: TEdit;
    edt12: TEdit;
    edt13: TEdit;
    edt14: TEdit;
    edt15: TEdit;
    btn2: TBitBtn;
    lbl11: TLabel;
    edt16: TEdit;
    edt17: TEdit;
    edt18: TEdit;
    grp3: TGroupBox;
    btn_showValues: TBitBtn;
    cht3: TChart;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Series10: TLineSeries;
    Series11: TLineSeries;
    Series12: TLineSeries;
    Series13: TLineSeries;
    btn3: TBitBtn;
    lst1: TListBox;
    procedure btn_processClick(Sender: TObject);
    procedure randomSeedGenerator(Series6 : TLineSeries; IDFT_result : array of Extended; lbledt_scaling : TLabeledEdit; lbledt_rr_mean : TLabeledEdit);
    procedure setValue;
    procedure showValue;
    procedure showEditValue;
    procedure btn_processRatioClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn_showValuesClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure RKThirdOrderMethod();
    procedure RKFourthOrderMethod();
    procedure RKSixthOrderMethod();
    procedure eulerMethod();
    procedure midpointMethod();
    procedure heunMethod();
    procedure ralstonMethod();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  N, f_ecg, f_int : Integer;
  A, h_mean, h_std, f_low, f_high, c_low, c_high, lf_hf_ratio : Extended;
  sigma_low, sigma_high, scaling, dt : Extended;
  rr_tachogram : array[0..10000] of Extended;

implementation

{$R *.dfm}
type
  TArrayOfExtended = array of Extended;
  ECGParts = (P, Q, R, S, T_plus, T_min);

var
  theta_param, a_param, b_param : array[ECGParts] of Extended;

function normalize(input : Extended) : Extended;
const
  SmallValue = 1e-10; // A more practical small value to avoid zero.
begin
  if (input = 0.0) then
    Result := SmallValue
  else
    Result := input;
end;

function modulus(input_1 : Extended; input_2 : Extended) : Extended;
begin
  while (input_1 >= input_2) do
  begin
    input_1 := input_1 - input_2;
  end;
  Result := input_1;
end;

function createSpectral(Series1: TLineSeries): TArrayOfExtended;
var
  i, fs : Integer;
  s1, s2, s : TArrayOfExtended;
  f : Extended;
begin
  Series1.Clear;
  SetLength(s1, N);
  SetLength(s2, N);
  SetLength(s, N);
  //  SetLength(f, N);

  for i := 0 to (N - 1) div 2 do
  begin
    fs := 1; // TODO
    f := i * fs/N;
    s1[i] := ((Power(sigma_low, 2))/(Sqrt(2 * PI * Power(c_low, 2)))) * Exp(-(Power(f - f_low, 2))/(2 * Power(c_low, 2)));
    s2[i] := ((Power(sigma_high, 2))/(Sqrt(2 * PI * Power(c_high, 2)))) * Exp(-(Power(f - f_high, 2))/(2 * Power(c_high, 2)));
    s[i] := s1[i] + s2[i];
    Series1.AddXY(f, s[i]);
  end;
  Result := s;
end;

function mirrorSpectral(Series2 : TLineSeries; spectral_result : TArrayOfExtended) : TArrayOfExtended;
var
  mirror_result, merge_result : TArrayOfExtended;
  i, fs, arr_length, half_arr_len : Integer;
  f : Extended;
begin
  Series2.Clear;
  arr_length := Length(spectral_result);
  half_arr_len := arr_length div 2;
  SetLength(mirror_result, half_arr_len);
  SetLength(merge_result, arr_length);

  for i := 0 to half_arr_len - 1 do
  begin
    mirror_result[i] := spectral_result[half_arr_len - 1 - i];
  end;

  for i := 0 to half_arr_len - 1 do
  begin
    merge_result[i] := spectral_result[i];
    merge_result[half_arr_len + i] := mirror_result[i];
  end;

  for i := 0 to arr_length - 1 do
  begin
    fs := 1; // TODO
    f := i * fs/N;
    Series2.AddXY(f, merge_result[i]);
  end;

  Result := merge_result;
end;

function IDFT(Series5 : TLineSeries; real : TArrayOfExtended; imag : TArrayOfExtended) : TArrayOfExtended;
var
  i, k : Integer;
  real_IDFT, imag_IDFT, IDFT_result : TArrayOfExtended;
begin
  Series5.Clear;
  SetLength(real_IDFT, N);
  SetLength(imag_IDFT, N);
  SetLength(IDFT_result, N);
  for i := 0 to N - 1 do
  begin
    for k := 0 to N - 1 do
    begin
      real_IDFT[i] := real_IDFT[i] + real[k] * Cos(2 * PI * k * i/N);
      imag_IDFT[i] := imag_IDFT[i] + imag[k] * Sin(2 * PI * k * i/N);
    end;
    IDFT_result[i] := (real_IDFT[i] + imag_IDFT[i])/N;
    Series5.AddXY(i, IDFT_result[i]);
  end;
  Result := IDFT_result;
end;

function randomPhaseGeneratorIDFT(Series3 : TLineSeries; Series4 : TLineSeries; Series5 : TLineSeries ; mirrored_result : TArrayOfExtended) : TArrayOfExtended;
var
  i : Integer;
  idft_result, real, imag : TArrayOfExtended;
begin
  Series3.Clear;
  Series4.Clear;
  SetLength(idft_result, N);
  SetLength(real, N);
  SetLength(imag, N);
  for i := 0 to N - 1 do
  begin
    real[i] := mirrored_result[i] * Cos(2 * PI * Random);
    imag[i] := mirrored_result[i] * Sin(2 * Pi * Random);
    Series3.AddXY(i/N, real[i]);
    Series4.AddXY(i/N, imag[i]);
  end;
  idft_result := IDFT(Series5, real, imag);
  Result := idft_result;
end;

procedure TForm1.randomSeedGenerator(Series6 : TLineSeries; IDFT_result : array of Extended; lbledt_scaling : TLabeledEdit; lbledt_rr_mean : TLabeledEdit);
var
  i : Integer;
  rr_mean : Extended;
 begin
  Series6.Clear;
  rr_mean := 60.0/h_mean;
  lbledt_rr_mean.Text := FloatToStr(rr_mean);
  for i := 0 to N - 1 do
  begin
    rr_tachogram[i] := rr_mean + scaling * IDFT_result[i];
    Series6.AddXY(i, rr_tachogram[i]);
  end;
end;

procedure TForm1.btn_processRatioClick(Sender: TObject);
begin
  lf_hf_ratio := StrToFloat(lbledt_lf_hf_ratio.Text);
  sigma_low := Sqrt(lf_hf_ratio) * sigma_high;
  showValue;
end;

procedure TForm1.setValue;
var
  i: Integer;
  labeledEdit: TLabeledEdit;
  var_name: String;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TLabeledEdit then
    begin
      labeledEdit := TLabeledEdit(Components[i]);
      if labeledEdit.Text <> '' then
      begin
        var_name := Copy(labeledEdit.Name, 8, Length(labeledEdit.Name) - 7);

        if var_name = 'N' then
          N := StrToInt(labeledEdit.Text)
        else if var_name = 'f_ecg' then
          f_ecg := StrToInt(labeledEdit.Text)
        else if var_name = 'f_int' then
          f_int := StrToInt(labeledEdit.Text)
        else if var_name = 'A' then
          A := StrToFloat(labeledEdit.Text)
        else if var_name = 'h_mean' then
          h_mean := StrToFloat(labeledEdit.Text)
        else if var_name = 'h_std' then
          h_std := StrToFloat(labeledEdit.Text)
        else if var_name = 'f_low' then
          f_low := StrToFloat(labeledEdit.Text)
        else if var_name = 'f_high' then
          f_high := StrToFloat(labeledEdit.Text)
        else if var_name = 'c_low' then
          c_low := StrToFloat(labeledEdit.Text)
        else if var_name = 'c_high' then
          c_high := StrToFloat(labeledEdit.Text)
        else if var_name = 'lf_hf_ratio' then
          lf_hf_ratio := StrToFloat(labeledEdit.Text)
        else if var_name = 'sigma_low' then
          sigma_low := StrToFloat(labeledEdit.Text)
        else if var_name = 'sigma_high' then
          sigma_high := StrToFloat(labeledEdit.Text)
        else if var_name = 'scaling' then
          scaling := StrToFloat(labeledEdit.Text);
      end;
    end;
  end;
end;

procedure TForm1.showValue;
var
  i: Integer;
  labeledEdit: TLabeledEdit;
  var_name: String;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TLabeledEdit then
    begin
      labeledEdit := TLabeledEdit(Components[i]);
      var_name := Copy(labeledEdit.Name, 8, Length(labeledEdit.Name) - 7);

      if var_name = 'N' then
        labeledEdit.Text := IntToStr(N)
      else if var_name = 'f_ecg' then
        labeledEdit.Text := IntToStr(f_ecg)
      else if var_name = 'f_int' then
        labeledEdit.Text := IntToStr(f_int)
      else if var_name = 'A' then
        labeledEdit.Text := FloatToStr(A)
      else if var_name = 'h_mean' then
        labeledEdit.Text := FloatToStr(h_mean)
      else if var_name = 'h_std' then
        labeledEdit.Text := FloatToStr(h_std)
      else if var_name = 'f_low' then
        labeledEdit.Text := FloatToStr(f_low)
      else if var_name = 'f_high' then
        labeledEdit.Text := FloatToStr(f_high)
      else if var_name = 'c_low' then
        labeledEdit.Text := FloatToStr(c_low)
      else if var_name = 'c_high' then
        labeledEdit.Text := FloatToStr(c_high)
      else if var_name = 'sigma_low' then
        labeledEdit.Text := FloatToStr(sigma_low)
      else if var_name = 'sigma_high' then
        labeledEdit.Text := FloatToStr(sigma_high)
      else if var_name = 'scaling' then
        labeledEdit.Text := FloatToStr(scaling)
      else if var_name = 'lf_hf_ratio' then
      begin
        lf_hf_ratio := Power(sigma_low, 2)/Power(sigma_high, 2);
        labeledEdit.Text := FloatToStr(lf_hf_ratio);
      end;
    end;
  end;
end;

procedure TForm1.showEditValue;
var
  part : ECGParts;
  i: Integer;
  edit: TEdit;
  var_name: String;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      edit := TEdit(Components[i]);
      var_name := edit.Name;

      if var_name = 'edt1' then
        edit.Text := FloatToStr(theta_param[P])
      else if var_name = 'edt2' then
        edit.Text := FloatToStr(theta_param[Q])
      else if var_name = 'edt3' then
        edit.Text := FloatToStr(theta_param[R])
      else if var_name = 'edt4' then
        edit.Text := FloatToStr(theta_param[S])
      else if var_name = 'edt5' then
        edit.Text := FloatToStr(theta_param[T_plus])
      else if var_name = 'edt6' then
        edit.Text := FloatToStr(theta_param[T_min])
      else if var_name = 'edt7' then
        edit.Text := FloatToStr(a_param[P])
      else if var_name = 'edt8' then
        edit.Text := FloatToStr(a_param[Q])
      else if var_name = 'edt9' then
        edit.Text := FloatToStr(a_param[R])
      else if var_name = 'edt10' then
        edit.Text := FloatToStr(a_param[S])
      else if var_name = 'edt11' then
        edit.Text := FloatToStr(a_param[T_plus])
      else if var_name = 'edt12' then
        edit.Text := FloatToStr(a_param[T_min])
      else if var_name = 'edt13' then
        edit.Text := FloatToStr(b_param[P])
      else if var_name = 'edt14' then
        edit.Text := FloatToStr(b_param[Q])
      else if var_name = 'edt15' then
        edit.Text := FloatToStr(b_param[R])
      else if var_name = 'edt16' then
        edit.Text := FloatToStr(b_param[S])
      else if var_name = 'edt17' then
        edit.Text := FloatToStr(b_param[T_plus])
      else if var_name = 'edt18' then
        edit.Text := FloatToStr(b_param[T_min])
    end;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  part : ECGParts;
begin
  theta_param[P] := StrToFloat(edt1.Text);
  theta_param[Q] := StrToFloat(edt2.Text);
  theta_param[R] := StrToFloat(edt3.Text);
  theta_param[S] := StrToFloat(edt4.Text);
  theta_param[T_plus] := StrToFloat(edt5.Text);
  theta_param[T_min] := StrToFloat(edt6.Text);

  a_param[P] := StrToFloat(edt7.Text);
  a_param[Q] := StrToFloat(edt8.Text);
  a_param[R] := StrToFloat(edt9.Text);
  a_param[S] := StrToFloat(edt10.Text);
  a_param[T_plus] := StrToFloat(edt11.Text);
  a_param[T_min] := StrToFloat(edt12.Text);

  b_param[P] := StrToFloat(edt13.Text);
  b_param[Q] := StrToFloat(edt14.Text);
  b_param[R] := StrToFloat(edt15.Text);
  b_param[S] := StrToFloat(edt16.Text);
  b_param[T_plus] := StrToFloat(edt17.Text);
  b_param[T_min] := StrToFloat(edt18.Text);
end;

procedure TForm1.btn3Click(Sender: TObject);
var
  part : ECGParts;
  hr_fact, hr_fact_root : Extended;
begin
  hr_fact := Sqrt(h_mean/60.0);
  hr_fact_root := Sqrt(hr_fact);

  for part := Low(ECGParts) to High(ECGParts) do
  begin
    b_param[part] := b_param[part] * hr_fact_root;
  end;

  theta_param[P] := theta_param[P] * hr_fact_root;
  theta_param[Q] := theta_param[Q] * hr_fact;
  theta_param[S] := theta_param[S] * hr_fact;
  theta_param[T_plus] := theta_param[T_plus] * hr_fact_root;
  theta_param[T_min] := theta_param[T_min] * hr_fact_root;
end;

function generateAngularVelocity(input: Extended): Extended;
const
  SmallValue = 0.00000001;  // A small value to avoid division by zero
var
  i: Integer;
begin
  i := 1 + Floor(input / dt);
  if rr_tachogram[i] = 0 then
    Result := 2.0 * Pi / SmallValue
  else
    Result := 2.0 * Pi / rr_tachogram[i];
end;

procedure TForm1.btn_showValuesClick(Sender: TObject);
begin
  showValue();
  showEditValue();
end;

function generateDynamicalXYZ(t_0: Extended; x_0: Extended; y_0: Extended; z_0: Extended; trig: Extended; lst1 : TListBox): Extended;
var
  part: ECGParts;
  a_0, te, det, det_2, temp, z_base: Extended;
begin
  // Clear the list box before adding new items
  lst1.Items.Clear;
  if (Abs(x_0) > 1e308) or (Abs(y_0) > 1e308) then
  begin
    x_0 := x_0 / 1e308;
    y_0 := y_0 / 1e308;
  end;
  a_0 := 1.0 - Sqrt((x_0 * x_0) + (y_0 * y_0));

  if (trig = 1) then
    begin
      Result := a_0 * x_0 - generateAngularVelocity(t_0) * y_0;
    end
  else if (trig = 2) then
    begin
      Result := a_0 * y_0 + generateAngularVelocity(t_0) * x_0;
    end
  else
    begin
      temp := 0;
      z_base := 0.005 * Sin(2 * Pi * t_0);
      te := ArcTan2(y_0, x_0);

      for part := Low(ECGParts) to High(ECGParts) do
      begin
        // Log the part index and any associated calculations
        lst1.Items.Add('Part: ' + IntToStr(Ord(part)) + ' - Theta: ' + FloatToStr(theta_param[part]));

        det := modulus(te - theta_param[part], 2 * Pi);
        det_2 := Power(det, 2);
        temp := temp - a_param[part] * det * Exp(-0.5 * det_2 / Power(b_param[part], 2));
      end;

      temp := temp - 1.0 * (z_0 - z_base);
      Result := temp;
    end;
end;

procedure TForm1.btn_processClick(Sender: TObject);
var
  i : Integer;
  spectral_result, mirrored_result, complex_spectrum : TArrayOfExtended;
begin
  SetLength(spectral_result, N);
  SetLength(mirrored_result, N);
  SetLength(complex_spectrum, N);
  setValue;
  showValue;
  showEditValue;
  dt := 1/f_ecg;
  spectral_result := createSpectral(Series1);
  for i := 0 to Length(spectral_result) - 1 do
  begin
    spectral_result[i] := Sqrt(spectral_result[i]);
  end;
  mirrored_result := mirrorSpectral(Series2, spectral_result);
  complex_spectrum := randomPhaseGeneratorIDFT(Series3, Series4, Series5, mirrored_result);
  randomSeedGenerator(Series6, complex_spectrum, lbledt_scaling, lbledt_rr_mean);
  eulerMethod();
  midpointMethod();
  heunMethod();
  ralstonMethod();
  RKThirdOrderMethod();
  RKFourthOrderMethod();
  RKSixthOrderMethod();
end;

procedure TForm1.eulerMethod();
var
  i: Integer;
  time_v : Extended;
  euler_Result : TArrayOfExtended;
begin
  Series7.Clear;
  SetLength(euler_Result, 3);
  euler_Result[0] := 0.1; //x initial condition
  euler_Result[1] := 0.0; //y initial condition
  euler_Result[2] := 0.04; //z initial condition
  time_v := 0.0;
  for i := 0 to Round(N) do
  begin
    euler_Result[0] := euler_Result[0] + dt * generateDynamicalXYZ(time_v, euler_Result[0], euler_Result[1], euler_Result[2], 1, lst1);
    euler_Result[1] := euler_Result[1] + dt * generateDynamicalXYZ(time_v, euler_Result[0], euler_Result[1], euler_Result[2], 2, lst1);
    euler_Result[2] := euler_Result[2] + dt * generateDynamicalXYZ(time_v, euler_Result[0], euler_Result[1], euler_Result[2], 3, lst1);
    time_v := time_v + dt;
    Series7.AddXY(time_v, euler_Result[2]);
   end;
end;

procedure TForm1.midpointMethod();
var
  i: Integer;
  time_v: Extended;
  midpoint_result, half_calc: array of Extended;
begin
  Series8.Clear;
  SetLength(midpoint_result, 3);
  SetLength(half_calc, 3);
  midpoint_result[0] := 0.1; //x initial condition
  midpoint_result[1] := 0.0; //y initial condition
  midpoint_result[2] := 0.04; //z initial condition
  time_v := 0;

  for i := 0 to Round(N) do
  begin
    half_calc[0] := midpoint_result[0] + dt/2 * generateDynamicalXYZ(time_v, midpoint_result[0], midpoint_result[1], midpoint_result[2], 1, lst1);
    half_calc[1] := midpoint_result[1] + dt/2 * generateDynamicalXYZ(time_v, midpoint_result[0], midpoint_result[1], midpoint_result[2], 2, lst1);
    half_calc[2] := midpoint_result[2] + dt/2 * generateDynamicalXYZ(time_v, midpoint_result[0], midpoint_result[1], midpoint_result[2], 3, lst1);
    time_v := time_v + dt/2;
    midpoint_result[0] := midpoint_result[0] + dt * generateDynamicalXYZ(time_v, half_calc[0], half_calc[1], half_calc[2], 1, lst1);
    midpoint_result[1] := midpoint_result[1] + dt * generateDynamicalXYZ(time_v, half_calc[0], half_calc[1], half_calc[2], 2, lst1);
    midpoint_result[2] := midpoint_result[2] + dt * generateDynamicalXYZ(time_v, half_calc[0], half_calc[1], half_calc[2], 3, lst1);
    time_v := time_v + dt/2;
    Series8.AddXY(time_v, midpoint_result[2]);
  end;
end;

procedure TForm1.heunMethod(); // One correction
var
  i: Integer;
  time_v : Extended;
  heun_result, predictor, corrector: array of Extended;
begin
  Series9.Clear;
  SetLength(heun_result, 3);
  SetLength(predictor, 3);
  SetLength(corrector, 3);
  heun_result[0] := 0.1; //x initial condition
  heun_result[1] := 0.0; //y initial condition
  heun_result[2] := 0.04; //z initial condition
  time_v := 0.0;

  for i := 0 to Round(N) do
  begin
    predictor[0] := heun_result[0] + dt * generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 1, lst1);
    predictor[1] := heun_result[1] + dt * generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 2, lst1);
    predictor[2] := heun_result[2] + dt * generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 3, lst1);
    corrector[0] := heun_result[0] + (dt / 2) * (generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 1, lst1) + generateDynamicalXYZ(time_v + dt, predictor[0], predictor[1], predictor[2], 1, lst1));
    corrector[1] := heun_result[1] + (dt / 2) * (generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 2, lst1) + generateDynamicalXYZ(time_v + dt, predictor[0], predictor[1], predictor[2], 2, lst1));
    corrector[2] := heun_result[2] + (dt / 2) * (generateDynamicalXYZ(time_v, heun_result[0], heun_result[1], heun_result[2], 3, lst1) + generateDynamicalXYZ(time_v + dt, predictor[0], predictor[1], predictor[2], 3, lst1));

    time_v := time_v + dt;
    heun_result[0] := corrector[0];
    heun_result[1] := corrector[1];
    heun_result[2] := corrector[2];

    Series9.AddXY(time_v, heun_result[2]);
  end;
end;

procedure TForm1.ralstonMethod();
var
  i: Integer;
  time_v : Extended;
  k1_x, k1_y, k1_z : Extended;
  k2_x, k2_y, k2_z : Extended;
  ralston_result: array of Extended;
begin
  Series10.Clear;
  SetLength(ralston_result, 3);
  time_v := 0;
  ralston_result[0] := 0.1; //x initial condition
  ralston_result[1] := 0.0; //y initial condition
  ralston_result[2] := 0.04; //z initial condition

  for i := 0 to Round(N) do
  begin
    k1_x := generateDynamicalXYZ(time_v, ralston_result[0], ralston_result[1], ralston_result[2], 1, lst1);
    k1_y := generateDynamicalXYZ(time_v, ralston_result[0], ralston_result[1], ralston_result[2], 2, lst1);
    k1_z := generateDynamicalXYZ(time_v, ralston_result[0], ralston_result[1], ralston_result[2], 3, lst1);

    k2_x := generateDynamicalXYZ(time_v + 0.75 * dt, ralston_result[0] + 0.75 * k1_x * dt, ralston_result[1] + 0.75 * k1_y * dt, ralston_result[2] + 0.75 * k1_z * dt, 1, lst1);
    k2_y := generateDynamicalXYZ(time_v + 0.75 * dt, ralston_result[0] + 0.75 * k1_x * dt, ralston_result[1] + 0.75 * k1_y * dt, ralston_result[2] + 0.75 * k1_z * dt, 2, lst1);
    k2_z := generateDynamicalXYZ(time_v + 0.75 * dt, ralston_result[0] + 0.75 * k1_x * dt, ralston_result[1] + 0.75 * k1_y * dt, ralston_result[2] + 0.75 * k1_z * dt, 3, lst1);

    ralston_result[0] := ralston_result[0] + (k1_x/3 + 2 * k2_x/3) * dt;
    ralston_result[1] := ralston_result[1] + (k1_y/3 + 2 * k2_y/3) * dt;
    ralston_result[2] := ralston_result[2] + (k1_z/3 + 2 * k2_z/3) * dt;

    time_v := time_v + dt;
    Series10.AddXY(time_v, ralston_result[2]);
  end;
end;

procedure TForm1.RKThirdOrderMethod();
var
  i: Integer;
  time_v : Extended;
  k1_x, k1_y, k1_z : Extended;
  k2_x, k2_y, k2_z : Extended;
  k3_x, k3_y, k3_z: Extended;
  RK_Result : array of Extended;
begin
  Series12.Clear;
  SetLength(RK_result, 3);
  time_v := 0;
  RK_Result[0] := 0.1; //x initial condition
  RK_Result[1] := 0.0; //y initial condition
  RK_result[2] := 0.04; //z initial condition

  for i := 0 to Round(N) do
  begin
    k1_x := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 1, lst1);
    k1_y := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 2, lst1);
    k1_z := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 3, lst1);


    k2_x := generateDynamicalXYZ(time_v + (dt/2), (RK_result[0] + 0.5 * k1_x * dt), (RK_result[1] + 0.5 * k1_y * dt), (RK_result[2] + 0.5 * k1_z * dt), 1, lst1);
    k2_y := generateDynamicalXYZ(time_v + (dt/2), (RK_result[0] + 0.5 * k1_x * dt), (RK_result[1] + 0.5 * k1_y * dt), (RK_result[2] + 0.5 * k1_z * dt), 2, lst1);
    k2_z := generateDynamicalXYZ(time_v + (dt/2), (RK_result[0] + 0.5 * k1_x * dt), (RK_result[1] + 0.5 * k1_y * dt), (RK_result[2] + 0.5 * k1_z * dt), 3, lst1);

    k3_x := generateDynamicalXYZ(time_v + dt, RK_result[0] - k1_x * dt + 2 * k2_x * dt, RK_result[1] - k1_y * dt + 2 * k2_y * dt, RK_result[2] - k1_z * dt + 2 * k2_z * dt, 1, lst1);
    k3_y := generateDynamicalXYZ(time_v + dt, RK_result[0] - k1_x * dt + 2 * k2_x * dt, RK_result[1] - k1_y * dt + 2 * k2_y * dt, RK_result[2] - k1_z * dt + 2 * k2_z * dt, 2, lst1);
    k3_z := generateDynamicalXYZ(time_v + dt, RK_result[0] - k1_x * dt + 2 * k2_x * dt, RK_result[1] - k1_y * dt + 2 * k2_y * dt, RK_result[2] - k1_z * dt + 2 * k2_z * dt, 3, lst1);

    RK_result[0] := RK_result[0] + (dt / 6) * (k1_x + 4 * k2_x + k3_x);
    RK_result[1] := RK_result[1] + (dt / 6) * (k1_y + 4 * k2_y + k3_y);
    RK_result[2] := RK_result[2] + (dt / 6) * (k1_z + 4 * k2_z + k3_z);

    time_v := time_v + dt;
    Series12.AddXY(time_v, RK_result[2]);
  end;
end;

procedure TForm1.RKFourthOrderMethod();
var
  i: Integer;
  time_v : Extended;
  k1_x, k1_y, k1_z : Extended;
  k2_x, k2_y, k2_z : Extended;
  k3_x, k3_y, k3_z : Extended;
  k4_x, k4_y, k4_z : Extended;
  RK_Result : TArrayOfExtended;
begin
  Series11.Clear;
  SetLength(RK_Result, 3);
  {Initial Condition}
  RK_Result[0] := 0.1; //x initial condition
  RK_Result[1] := 0.0; //y initial condition
  RK_Result[2] := 0.04; //z initial condition
  time_v := 0.0;

  for i := 0 to Round(N) do
  begin
    {Konstanta 1}
    k1_x := generateDynamicalXYZ(time_v, RK_Result[0], RK_Result[1], RK_Result[2], 1, lst1);
    k1_y := generateDynamicalXYZ(time_v, RK_Result[0], RK_Result[1], RK_Result[2], 2, lst1);
    k1_z := generateDynamicalXYZ(time_v, RK_Result[0], RK_Result[1], RK_Result[2], 3, lst1);

    {Konstanta 2}
    k2_x := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k1_x, RK_Result[1] + 0.5 * dt * k1_y, RK_Result[2] + 0.5 * dt * k1_z, 1, lst1);
    k2_y := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k1_x, RK_Result[1] + 0.5 * dt * k1_y, RK_Result[2] + 0.5 * dt * k1_z, 2, lst1);
    k2_z := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k1_x, RK_Result[1] + 0.5 * dt * k1_y, RK_Result[2] + 0.5 * dt * k1_z, 3, lst1);

    {Konstanta 3}
    k3_x := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k2_x, RK_Result[1] + 0.5 * dt * k2_y, RK_Result[2] + 0.5 * dt * k2_z, 1, lst1);
    k3_y := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k2_x, RK_Result[1] + 0.5 * dt * k2_y, RK_Result[2] + 0.5 * dt * k2_z, 2, lst1);
    k3_z := generateDynamicalXYZ(time_v + dt/2, RK_Result[0] + 0.5 * dt * k2_x, RK_Result[1] + 0.5 * dt * k2_y, RK_Result[2] + 0.5 * dt * k2_z, 3, lst1);

    {Konstanta 4}
    k4_x := generateDynamicalXYZ(time_v + dt, RK_Result[0] + dt * k3_x, RK_Result[1] + dt * k3_y, RK_Result[2] + dt * k3_z, 1, lst1);
    k4_y := generateDynamicalXYZ(time_v + dt, RK_Result[0] + dt * k3_x, RK_Result[1] + dt * k3_y, RK_Result[2] + dt * k3_z, 2, lst1);
    k4_z := generateDynamicalXYZ(time_v + dt, RK_Result[0] + dt * k3_x, RK_Result[1] + dt * k3_y, RK_Result[2] + dt * k3_z, 3, lst1);

    RK_Result[0] := RK_Result[0] + (dt/6) * (k1_x + 2 * k2_x + 2 * k3_x + k4_x);
    RK_Result[1] := RK_Result[1] + (dt/6) * (k1_y + 2 * k2_y + 2 * k3_y + k4_y);
    RK_Result[2] := RK_Result[2] + (dt/6) * (k1_z + 2 * k2_z + 2 * k3_z + k4_z);

    time_v := time_v + dt;
    Series11.AddXY(time_v, RK_Result[2]);
  end;
end;

procedure TForm1.RKSixthOrderMethod();
var
  i: Integer;
  time_v : Extended;
  k1_x, k1_y, k1_z : Extended;
  k2_x, k2_y, k2_z : Extended;
  k3_x, k3_y, k3_z : Extended;
  k4_x, k4_y, k4_z : Extended;
  k5_x, k5_y, k5_z : Extended;
  k6_x, k6_y, k6_z : Extended;
  RK_Result : array of Extended;
begin
  Series13.Clear;
  SetLength(RK_result, 3);
  time_v := 0;
  RK_Result[0] := 0.1; //x initial condition
  RK_Result[1] := 0.0; //y initial condition
  RK_Result[2] := 0.04; //z initial condition

  for i := 0 to Round(N) do
  begin
    k1_x := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 1, lst1);
    k1_y := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 2, lst1);
    k1_z := generateDynamicalXYZ(time_v, RK_result[0], RK_result[1], RK_result[2], 3, lst1);

    k2_x := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + 0.25 * k1_x * dt), (RK_result[1] + 0.25 * k1_y * dt), (RK_result[2] + 0.25 * k1_z * dt), 1, lst1);
    k2_y := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + 0.25 * k1_x * dt), (RK_result[1] + 0.25 * k1_y * dt), (RK_result[2] + 0.25 * k1_z * dt), 2, lst1);
    k2_z := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + 0.25 * k1_x * dt), (RK_result[1] + 0.25 * k1_y * dt), (RK_result[2] + 0.25 * k1_z * dt), 3, lst1);

    k3_x := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + (k1_x * dt)/8 + (k2_x * dt)/8), (RK_result[1] + (k1_y * dt)/8 + (k2_y * dt)/8), (RK_result[2] + (k1_z * dt)/8 + (k2_z * dt)/8), 1, lst1);
    k3_y := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + (k1_x * dt)/8 + (k2_x * dt)/8), (RK_result[1] + (k1_y * dt)/8 + (k2_y * dt)/8), (RK_result[2] + (k1_z * dt)/8 + (k2_z * dt)/8), 2, lst1);
    k3_z := generateDynamicalXYZ(time_v + dt/4, (RK_result[0] + (k1_x * dt)/8 + (k2_x * dt)/8), (RK_result[1] + (k1_y * dt)/8 + (k2_y * dt)/8), (RK_result[2] + (k1_z * dt)/8 + (k2_z * dt)/8), 3, lst1);

    k4_x := generateDynamicalXYZ(time_v + dt/2, RK_result[0] - 0.5 * k2_x * dt + k3_x * dt, RK_result[1] - 0.5 * k2_y * dt + k3_y * dt, RK_result[2] - 0.5 * k2_z * dt + k3_z * dt, 1, lst1);
    k4_y := generateDynamicalXYZ(time_v + dt/2, RK_result[0] - 0.5 * k2_x * dt + k3_x * dt, RK_result[1] - 0.5 * k2_y * dt + k3_y * dt, RK_result[2] - 0.5 * k2_z * dt + k3_z * dt, 2, lst1);
    k4_z := generateDynamicalXYZ(time_v + dt/2, RK_result[0] - 0.5 * k2_x * dt + k3_x * dt, RK_result[1] - 0.5 * k2_y * dt + k3_y * dt, RK_result[2] - 0.5 * k2_z * dt + k3_z * dt, 3, lst1);

    k5_x := generateDynamicalXYZ(time_v + 0.75 * dt, RK_result[0] + (3 * k1_x * dt)/16 + (9 * k4_x * dt)/16, RK_result[1] + (3 * k1_y * dt)/16 + (9 * k4_y * dt)/16, RK_result[2] + (3 * k1_z * dt)/16 + (9 * k4_z * dt)/16, 1, lst1);
    k5_y := generateDynamicalXYZ(time_v + 0.75 * dt, RK_result[0] + (3 * k1_x * dt)/16 + (9 * k4_x * dt)/16, RK_result[1] + (3 * k1_y * dt)/16 + (9 * k4_y * dt)/16, RK_result[2] + (3 * k1_z * dt)/16 + (9 * k4_z * dt)/16, 2, lst1);
    k5_z := generateDynamicalXYZ(time_v + 0.75 * dt, RK_result[0] + (3 * k1_x * dt)/16 + (9 * k4_x * dt)/16, RK_result[1] + (3 * k1_y * dt)/16 + (9 * k4_y * dt)/16, RK_result[2] + (3 * k1_z * dt)/16 + (9 * k4_z * dt)/16, 3, lst1);

    k6_x := generateDynamicalXYZ(time_v + dt, RK_result[0] - (0.42 * k1_x * dt) + (0.28 * k2_x * dt) + (1.71 * k3_x * dt) - (1.71 * k4_x * dt) + (1.14 * k5_x * dt), RK_result[1] - (0.42 * k1_y * dt) + (0.28 * k2_y * dt) + (1.71 * k3_y * dt) - (1.71 * k4_y * dt) + (1.14 * k5_y * dt), RK_result[2] - (0.42 * k1_z * dt) + (0.28 * k2_z * dt) + (1.71 * k3_z * dt) - (1.71 * k4_z * dt) + (1.14 * k5_z * dt), 1, lst1);
    k6_y := generateDynamicalXYZ(time_v + dt, RK_result[0] - (0.42 * k1_x * dt) + (0.28 * k2_x * dt) + (1.71 * k3_x * dt) - (1.71 * k4_x * dt) + (1.14 * k5_x * dt), RK_result[1] - (0.42 * k1_y * dt) + (0.28 * k2_y * dt) + (1.71 * k3_y * dt) - (1.71 * k4_y * dt) + (1.14 * k5_y * dt), RK_result[2] - (0.42 * k1_z * dt) + (0.28 * k2_z * dt) + (1.71 * k3_z * dt) - (1.71 * k4_z * dt) + (1.14 * k5_z * dt), 2, lst1);
    k6_z := generateDynamicalXYZ(time_v + dt, RK_result[0] - (0.42 * k1_x * dt) + (0.28 * k2_x * dt) + (1.71 * k3_x * dt) - (1.71 * k4_x * dt) + (1.14 * k5_x * dt), RK_result[1] - (0.42 * k1_y * dt) + (0.26 * k2_y * dt) + (1.71 * k3_y * dt) - (1.71 * k4_y * dt) + (1.14 * k5_y * dt), RK_result[2] - (0.42 * k1_z * dt) + (0.28 * k2_z * dt) + (1.71 * k3_z * dt) - (1.71 * k4_z * dt) + (1.14 * k5_z * dt), 3, lst1);

    RK_result[0] := RK_result[0] + (dt / 90) * (7 * k1_x + 32 * k3_x + 12 * k4_x + 32 * k5_x + 7 * k6_x);
    RK_result[1] := RK_result[1] + (dt / 90) * (7 * k1_y + 32 * k3_y + 12 * k4_y + 32 * k5_y + 7 * k6_y);
    RK_result[2] := RK_result[2] + (dt / 90) * (7 * k1_z + 32 * k3_z + 12 * k4_z + 32 * k5_z + 7 * k6_z);

    time_v := time_v + dt;
    Series13.AddXY(time_v, RK_result[2]);
  end;
end;

begin
  N := 2560;
  f_ecg := 256;
  f_int := 512;
  A := 0.1;
  h_mean := 60.0;
  h_std := 1.0;
  f_low := 0.1;
  f_high := 0.25;
  c_low := 0.01;
  c_high := 0.01;
  sigma_low := 0.25;
  sigma_high := Sqrt(2)/4;
  scaling := 1.0;

  // default values
  theta_param[P] := -90.0;
  theta_param[Q] := -15.0;
  theta_param[R] := 0.0;
  theta_param[S] := 15.0;
  theta_param[T_plus] := 5.0;
  theta_param[T_min] := -80.0; // TODO

  a_param[P] := 0.6;
  a_param[Q] := -5.0;
  a_param[R] := 80.0;
  a_param[S] := -7.5;
  a_param[T_plus] := 0.4;
  a_param[T_min] := 0.75; // TODO

  b_param[P] := 0.5;
  b_param[Q] := 0.1;
  b_param[R] := 0.1;
  b_param[S] := 0.1;
  b_param[T_plus] := 0.4;
  b_param[T_min] := 0.4; // TODO
end.

