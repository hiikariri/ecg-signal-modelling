object Form1: TForm1
  Left = 190
  Top = 167
  Width = 1423
  Height = 738
  Caption = 'ECG Synthetic'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 10
    Width = 241
    Height = 519
    Caption = 'Temporal and Spectral Parameters'
    TabOrder = 1
    object lbledt_N: TLabeledEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      EditLabel.Width = 189
      EditLabel.Height = 13
      EditLabel.Caption = 'Approximate Number of Heartbeats (N)'
      HideSelection = False
      TabOrder = 0
    end
    object lbledt_c_high: TLabeledEdit
      Left = 16
      Top = 400
      Width = 121
      Height = 21
      EditLabel.Width = 212
      EditLabel.Height = 13
      EditLabel.Caption = 'High Frequency Standard Deviation (c_high)'
      TabOrder = 9
    end
    object lbledt_c_low: TLabeledEdit
      Left = 16
      Top = 360
      Width = 121
      Height = 21
      EditLabel.Width = 206
      EditLabel.Height = 13
      EditLabel.Caption = 'Low Frequency Standard Deviation (c_low)'
      TabOrder = 8
    end
    object lbledt_f_high: TLabeledEdit
      Left = 16
      Top = 320
      Width = 121
      Height = 21
      EditLabel.Width = 116
      EditLabel.Height = 13
      EditLabel.Caption = 'High Frequency (f_high)'
      TabOrder = 7
    end
    object lbledt_f_low: TLabeledEdit
      Left = 16
      Top = 280
      Width = 121
      Height = 21
      EditLabel.Width = 110
      EditLabel.Height = 13
      EditLabel.Caption = 'Low Frequency (f_low)'
      TabOrder = 6
    end
    object lbledt_h_std: TLabeledEdit
      Left = 16
      Top = 240
      Width = 121
      Height = 21
      EditLabel.Width = 183
      EditLabel.Height = 13
      EditLabel.Caption = 'Heart rate Standard Deviation (h_std)'
      TabOrder = 5
    end
    object lbledt_h_mean: TLabeledEdit
      Left = 16
      Top = 200
      Width = 121
      Height = 21
      EditLabel.Width = 128
      EditLabel.Height = 13
      EditLabel.Caption = 'Heart rate Mean (h_mean)'
      TabOrder = 4
    end
    object lbledt_A: TLabeledEdit
      Left = 16
      Top = 160
      Width = 121
      Height = 21
      EditLabel.Width = 189
      EditLabel.Height = 13
      EditLabel.Caption = 'Amplitude of Additive Uniform Noise (A)'
      TabOrder = 3
    end
    object lbledt_f_int: TLabeledEdit
      Left = 16
      Top = 120
      Width = 121
      Height = 21
      EditLabel.Width = 168
      EditLabel.Height = 13
      EditLabel.Caption = 'Internal Samping Frequency (f_int)'
      TabOrder = 2
    end
    object lbledt_f_ecg: TLabeledEdit
      Left = 16
      Top = 80
      Width = 121
      Height = 21
      EditLabel.Width = 157
      EditLabel.Height = 13
      EditLabel.Caption = 'ECG Sampling Frequency (f_ecg)'
      TabOrder = 1
    end
    object lbledt_lf_hf_ratio: TLabeledEdit
      Left = 104
      Top = 456
      Width = 121
      Height = 21
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'LF/HF Ratio'
      TabOrder = 10
    end
    object lbledt_sigma_low: TLabeledEdit
      Left = 16
      Top = 440
      Width = 73
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Sigma Low'
      TabOrder = 11
    end
    object lbledt_sigma_high: TLabeledEdit
      Left = 16
      Top = 480
      Width = 73
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Sigma High'
      TabOrder = 12
    end
    object btn_processRatio: TBitBtn
      Left = 104
      Top = 480
      Width = 121
      Height = 25
      Caption = 'Input Ratio'
      TabOrder = 13
      OnClick = btn_processRatioClick
    end
  end
  object cht_spectral: TChart
    Left = 256
    Top = 16
    Width = 400
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'Spectral Characteristic')
    BottomAxis.Title.Caption = 'freq (Hz)'
    LeftAxis.Title.Caption = '|H(jw)|'
    View3D = False
    TabOrder = 0
    object Series1: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
  end
  object cht_spectral1: TChart
    Left = 664
    Top = 16
    Width = 400
    Height = 250
    Legend.Visible = False
    Title.Text.Strings = (
      'Mirroring and Sqrt')
    BottomAxis.ExactDateTime = False
    BottomAxis.Increment = 0.100000000000000000
    BottomAxis.Title.Caption = 'freq (Hz)'
    LeftAxis.Title.Caption = '|H(jw)|'
    View3D = False
    TabOrder = 2
    object Series2: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
  end
  object cht1: TChart
    Left = 256
    Top = 280
    Width = 400
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'Generated Random Phase')
    BottomAxis.Title.Caption = 'freq (Hz)'
    LeftAxis.Title.Caption = '|H(jw)|'
    View3D = False
    TabOrder = 3
    PrintMargins = (
      15
      25
      15
      25)
    object Series3: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clRed
      Title = 'Real'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series4: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clGreen
      Title = 'Imag'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
  end
  object cht2: TChart
    Left = 664
    Top = 280
    Width = 400
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'RR Tachogram')
    BottomAxis.Title.Caption = 'Sequence (n)'
    LeftAxis.Title.Caption = 'RR Interval (s)'
    View3D = False
    TabOrder = 4
    object Series5: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clRed
      Title = 'Before'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series6: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clGreen
      Title = 'After'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
  end
  object grp2: TGroupBox
    Left = 1080
    Top = 16
    Width = 297
    Height = 249
    Caption = 'Morphological Parameters'
    TabOrder = 5
    object lbl1: TLabel
      Left = 16
      Top = 48
      Width = 7
      Height = 16
      Caption = 'P'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 16
      Top = 72
      Width = 9
      Height = 16
      Caption = 'Q'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl3: TLabel
      Left = 16
      Top = 96
      Width = 8
      Height = 16
      Caption = 'R'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl4: TLabel
      Left = 16
      Top = 120
      Width = 8
      Height = 16
      Caption = 'S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl5: TLabel
      Left = 16
      Top = 144
      Width = 16
      Height = 16
      Caption = 'T+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl6: TLabel
      Left = 56
      Top = 24
      Width = 33
      Height = 16
      Caption = 'Theta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl7: TLabel
      Left = 152
      Top = 24
      Width = 7
      Height = 16
      Caption = 'a'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl8: TLabel
      Left = 232
      Top = 24
      Width = 7
      Height = 16
      Caption = 'b'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl11: TLabel
      Left = 16
      Top = 168
      Width = 13
      Height = 16
      Caption = 'T-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edt1: TEdit
      Left = 40
      Top = 48
      Width = 73
      Height = 21
      TabOrder = 0
    end
    object edt2: TEdit
      Left = 40
      Top = 72
      Width = 73
      Height = 21
      TabOrder = 1
    end
    object edt3: TEdit
      Left = 40
      Top = 96
      Width = 73
      Height = 21
      TabOrder = 2
    end
    object edt4: TEdit
      Left = 40
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 3
    end
    object edt5: TEdit
      Left = 40
      Top = 144
      Width = 73
      Height = 21
      TabOrder = 4
    end
    object edt6: TEdit
      Left = 40
      Top = 168
      Width = 73
      Height = 21
      TabOrder = 5
    end
    object edt7: TEdit
      Left = 120
      Top = 48
      Width = 73
      Height = 21
      TabOrder = 6
    end
    object edt8: TEdit
      Left = 120
      Top = 72
      Width = 73
      Height = 21
      TabOrder = 7
    end
    object edt9: TEdit
      Left = 120
      Top = 96
      Width = 73
      Height = 21
      TabOrder = 8
    end
    object edt10: TEdit
      Left = 120
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 9
    end
    object edt11: TEdit
      Left = 120
      Top = 144
      Width = 73
      Height = 21
      TabOrder = 10
    end
    object edt12: TEdit
      Left = 120
      Top = 168
      Width = 73
      Height = 21
      TabOrder = 11
    end
    object edt13: TEdit
      Left = 200
      Top = 48
      Width = 73
      Height = 21
      TabOrder = 12
    end
    object edt14: TEdit
      Left = 200
      Top = 72
      Width = 73
      Height = 21
      TabOrder = 13
    end
    object edt15: TEdit
      Left = 200
      Top = 96
      Width = 73
      Height = 21
      TabOrder = 14
    end
    object btn2: TBitBtn
      Left = 16
      Top = 200
      Width = 75
      Height = 33
      Caption = 'Input'
      TabOrder = 15
      OnClick = btn2Click
    end
    object edt16: TEdit
      Left = 200
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 16
    end
    object edt17: TEdit
      Left = 200
      Top = 144
      Width = 73
      Height = 21
      TabOrder = 17
    end
    object edt18: TEdit
      Left = 200
      Top = 168
      Width = 73
      Height = 21
      TabOrder = 18
    end
    object btn3: TBitBtn
      Left = 96
      Top = 200
      Width = 177
      Height = 33
      Caption = 'Calculate Modulation Factor'
      TabOrder = 19
      OnClick = btn3Click
    end
  end
  object grp3: TGroupBox
    Left = 1080
    Top = 280
    Width = 297
    Height = 145
    Caption = 'Control Panel'
    TabOrder = 6
    object lbledt_rr_mean: TLabeledEdit
      Left = 80
      Top = 100
      Width = 65
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = 'RR Mean'
      TabOrder = 0
    end
    object lbledt_scaling: TLabeledEdit
      Left = 8
      Top = 100
      Width = 65
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'Scaling'
      TabOrder = 1
    end
    object btn1: TBitBtn
      Left = 152
      Top = 24
      Width = 137
      Height = 49
      TabOrder = 2
      Kind = bkClose
    end
    object btn_process: TBitBtn
      Left = 8
      Top = 24
      Width = 137
      Height = 49
      Caption = 'Process'
      TabOrder = 3
      OnClick = btn_processClick
    end
    object btn_showValues: TBitBtn
      Left = 152
      Top = 88
      Width = 137
      Height = 33
      Caption = 'Show Parameters Value'
      TabOrder = 4
      OnClick = btn_showValuesClick
    end
  end
  object cht3: TChart
    Left = 8
    Top = 536
    Width = 1369
    Height = 249
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'Synthetic ECG Signal')
    BottomAxis.Title.Caption = 'Time (s)'
    LeftAxis.Title.Caption = 'Amplitude (mV)'
    View3D = False
    TabOrder = 7
    object Series7: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series8: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clGreen
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series9: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = 16711808
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series10: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clBlue
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series11: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clBlack
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series12: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clGray
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
    object Series13: TLineSeries
      Marks.ArrowLength = 8
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      SeriesColor = clFuchsia
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
    end
  end
  object lst1: TListBox
    Left = 1080
    Top = 432
    Width = 297
    Height = 97
    ItemHeight = 13
    TabOrder = 8
  end
end
