program SchoolCalendar;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {SCalendar},
  XSuperJSON in '..\x-superobject\XSuperJSON.pas',
  XSuperObject in '..\x-superobject\XSuperObject.pas',
  Google.OAuth in '..\OAuthClient\Google.OAuth.pas',
  EventTabUnit in 'EventTabUnit.pas' {EventTabFrame: TFrame},
  DayUnit in 'DayUnit.pas' {DayFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait];
  Application.CreateForm(TSCalendar, SCalendar);
  Application.Run;
end.
