unit main;

{$mode objfpc}{$H+}

interface

uses
  ActnList, Classes, generics.Collections, LazUTF8, SysUtils, Forms, Controls,
  Graphics, Dialogs, uframe;

type
  TFrameList = specialize TObjectList<TfrmFrame>;

  { TfrmMain }

  TfrmMain = class(TForm)
    ActFrameAdd: TAction;
    ActFrameDel: TAction;
    ActList: TActionList;
    ScrollBox1: TScrollBox;
    procedure ActFrameAddExecute(Sender: TObject);
    procedure ActFrameDelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFrameList: TFrameList;
    FFrameCounter: PtrInt;
  public
    property FrameList: TFrameList read FFrameList;
  end;

const
  MaxPnlCount = 3;
var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FFrameList:= TFrameList.Create(True);
  FFrameCounter:= 0;
end;

procedure TfrmMain.ActFrameDelExecute(Sender: TObject);
begin
//
end;

procedure TfrmMain.ActFrameAddExecute(Sender: TObject);
var
  frNum: PtrInt = 0;
  currFrame: TfrmFrame = nil;
  ErrMsg: String = '';
begin
  if not Assigned(FFrameList) then Exit;
  if (FrameList.Count > Pred(MaxPnlCount)) then Exit; //max frames count

  Self.BeginFormUpdate;
  try
    try
      currFrame:= TfrmFrame.Create(Self);
      frNum:= FrameList.Add(currFrame);
      with currFrame do
      begin
        inc(FFrameCounter);
        Name:= 'frame_' + IntToStr(FFrameCounter);
        Parent:= ScrollBox1;

        if (frNum = 0) //get Top control
        then
          begin
            AnchorSideTop.Side:= asrTop;
            AnchorSideTop.Control:= Parent;
          end
        else
          begin
            AnchorSideTop.Side:= asrBottom;
            AnchorSideTop.Control:= FrameList.Items[Pred(frNum)];
          end;

          //Enabled/Disabled L- R-buttons
          {$IF DEFINED(MSWINDOWS) or DEFINED(LCLQt) or DEFINED(LCLQt5)}
          btnLeft.Enabled:=
            not (currFrame.Equals(FrameList.Last) and (frNum = pred(MaxPnlCount)));
          btnRight.Enabled:=
            not currFrame.Equals(FrameList.First);

          btnLeft.Caption:= '+';
          btnLeft.OnClick:= @ActFrameAddExecute;
          btnRight.Caption:= '-';
          btnRight.OnClick:= @ActFrameDelExecute;
          {$ELSE}
          btnRight.Enabled:=
            not (currFrame.Equals(FrameList.Last) and (frNum = pred(MaxPnlCount)));
          btnLeft.Enabled:=
            not currFrame.Equals(FrameList.First);

          btnRight.Caption:= '+';
          btnRight.OnClick:= @ActFrameAddExecute;
          btnLeft.Caption:= '-';
          btnLeft.OnClick:= @ActFrameDelExecute;
          {$ENDIF}

          Visible:= True;
      end;
    except
      on E:Exception do
      begin
        if Assigned(currFrame) then FreeAndNil(currFrame);

        {$IFDEF MSWINDOWS}
        ErrMsg:= WinCPToUTF8(E.Message);
        {$ELSE}
        ErrMsg:= E.Message;
        {$ENDIF}

        ShowMessage(ErrMsg);
      end;
    end;
  finally
    Self.EndFormUpdate;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FFrameList.Free;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  ActFrameAddExecute(Sender);
end;

end.

