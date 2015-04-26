unit EventTabUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TEventTabFrame = class(TFrame)
    EndTimeLabel: TLabel;
    LessonPanel: TPanel;
    RoomLabel: TLabel;
    TeacherLabel: TLabel;
    StartTimeLabel: TLabel;
    SummaryLabel: TLabel;
    TimeLeftLabel: TLabel;
    TimeLeftEndLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
