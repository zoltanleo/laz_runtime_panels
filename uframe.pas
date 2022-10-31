unit uframe;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, ExtCtrls, StdCtrls, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TfrmFrame }

  TfrmFrame = class(TForm)
    Bevel1: TBevel;
    btnLeft: TButton;
    btnRight: TButton;
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmFrame: TfrmFrame;

implementation

{$R *.lfm}

{ TfrmFrame }

procedure TfrmFrame.FormShow(Sender: TObject);
begin
  with Self do
  begin
    Align:= alCustom;
    BorderStyle:= bsNone;
    ShowInTaskBar:= stNever;
    AutoSize:= True;
    AnchorSideLeft.Control:= Parent;
    AnchorSideRight.Control:= Parent;
    AnchorSideLeft.Side:= asrLeft;
    AnchorSideRight.Side:= asrRight;
    Anchors:= [akLeft,akTop,akRight];
  end;

  btnRight.Width:= ComboBox1.Height;
  btnLeft.Width:= ComboBox1.Height;
end;

end.

