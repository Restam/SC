program SchoolCalendar;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {SCalendar},
  XSuperJSON in '..\x-superobject\XSuperJSON.pas',
  XSuperObject in '..\x-superobject\XSuperObject.pas',
  Google.OAuth in '..\OAuthClient\Google.OAuth.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSCalendar, SCalendar);
  Application.Run;
end.
