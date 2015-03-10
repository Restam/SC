unit MainUnit;

interface

uses
  System.SysUtils, System.JSON, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Google.OAuth, HttpApp,DateUtils,
  FMX.StdCtrls, System.Actions, FMX.ActnList, FMX.Menus, FMX.Layouts, XSuperJson, XSuperObject,
  FMX.Gestures, FMX.Controls.Presentation, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls, System.IOUtils, FMX.WebBrowser
  {$IFDEF WIN32}
    ,ShellApi, Windows, FMX.Calendar;
  {$ElSE}
    ,FMX.Calendar;
  {$ENDIF}

type
  TSCalendar = class(TForm)
    GoogleClient: TOAuthClient;
    RefreshTokenTimer: TTimer;
    MainMenu: TMainMenu;
    AccountItem: TMenuItem;
    SettingsItem: TMenuItem;
    EventsManager: TGestureManager;
    GeustureList: TActionList;
    LeftRightPanning: TAction;
    RightLeftPanning: TAction;
    LoginPanel: TCalloutPanel;
    Login: TButton;
    RememberMeBox: TCheckBox;
    KeyEdit: TEdit;
    LeftPanel: TPanel;
    MainPanel: TPanel;
    CalendarItem: TMenuItem;
    EventBox: TListBox;
    SummaryLabel: TLabel;
    TeacherLabel: TLabel;
    EndTimeLabel: TLabel;
    EditSaveButton: TButton;
    WebBrowser: TWebBrowser;
    TopDownPanning: TAction;
    DownTopPanning: TAction;
    ToTimer: TTimer;
    UpdateTimer: TTimer;
    HelpButton: TSpeedButton;
    MenuPanel: TPanel;
    EventsSButton: TSpeedButton;
    TimerSButton: TSpeedButton;
    CalendarSButton: TSpeedButton;
    StyleBook1: TStyleBook;
    RoomLabel: TLabel;
    StartTimeLabel: TLabel;
    RoomEdit: TEdit;
    TeacherEdit: TEdit;
    StartTimeEdit: TEdit;
    EndTimeEdit: TEdit;
    LeftLabel: TLabel;
    TimeLabel: TLabel;
    ToLabel: TLabel;
    TimePanel: TPanel;
    ShadowPanel: TPanel;
    ChCaPanel: TPanel;
    CalendarBox: TComboBox;
    ChCaLabel: TLabel;
    FilterBox: TComboBox;
    UpEventsButton: TButton;
    LessonPanel: TPanel;
    procedure LeftRightPanningExecute(Sender: TObject);
    procedure RightLeftPanningExecute(Sender: TObject);
    procedure EventsControlGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure LoginClick(Sender: TObject);
    procedure AccountItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CalendarItemClick(Sender: TObject);
    procedure MainPanelClick(Sender: TObject);
    procedure UpEventsButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EventBoxClick(Sender: TObject);
    procedure TopDownPanningExecute(Sender: TObject);
    procedure DownTopPanningExecute(Sender: TObject);
    procedure WebBrowserShouldStartLoadWithRequest(ASender: TObject;
      const URL: string);
    procedure RefreshTokenTimerTimer(Sender: TObject);
    procedure ToTimerTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure EventsSButtonClick(Sender: TObject);
    procedure TimerSButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateCalendarMenu;
    procedure UpdateCalendarEvents(AFilter: Integer);
    procedure UpdateEventView;
    procedure EventCheckDescription(AEventDescription: String);
    procedure ShowTimer(ShowState: Boolean);
    procedure ShowChCaPanel(ShowState: Boolean);
  public
    { Public declarations }
  end;
    //function EncodeURIComponent(const ASrc: string): UTF8String;
    procedure RearrangeEvents;
    function BuildRequest(AFilter: Integer): String;
var
  SCalendar: TSCalendar;
  CalendarList, EventList: TStringList;
  FormatSettings: TFormatSettings;
  GAccess: String;
implementation

{$R *.fmx}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

procedure RearrangeEvents;
var
  i, Mid: Integer;
begin
  Mid := (EventList.Count-1) div 2;
  for i := 0 to Mid do
  begin
    EventList.Exchange(i,EventList.Count-1-i);
    SCalendar.EventBox.Items.Exchange(i,EventList.Count-1-i);
  end;
end;

procedure TSCalendar.AccountItemClick(Sender: TObject);
begin
  if not LoginPanel.Visible then
    LoginPanel.Visible := True
  else
    LoginPanel.Visible := False;
end;

procedure TSCalendar.CalendarItemClick(Sender: TObject);
begin
  if not ChCaPanel.Visible then
    ShowChCaPanel(True)
  else
    ShowChCaPanel(False)
end;

procedure TSCalendar.DownTopPanningExecute(Sender: TObject);
begin
  {if ChCaPanel.Visible then
  begin
    ChCaPanel.Visible := False;
    ChCaPanel.SendToBack;
  end
  else
  begin
    ToTimer.Enabled := True;
    TimePanel.Visible := True;
    TimePanel.BringToFront;
  end; }
end;

procedure TSCalendar.EventBoxClick(Sender: TObject);
begin
  try
    UpdateEventView;
  except
  end;
end;

procedure TSCalendar.EventCheckDescription(AEventDescription: String);
var
  stpos: Integer;
  JsonObject: ISuperObject;
begin
  if AEventDescription.Contains('#lesson') then
    begin
      stpos := AEventDescription.IndexOfAny('#lesson'.ToCharArray);
      AEventDescription := AEventDescription.Remove(stpos,'#lesson'.Length);
      JsonObject := SO(AEventDescription);
      TeacherEdit.Text := JsonObject.S['teacher'];
      RoomEdit.Text := JsonObject.S['room'];
      LessonPanel.Visible := True;
    end
  else
    LessonPanel.Visible := False;
end;

procedure TSCalendar.EventsControlGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  S: String;
begin
  if GestureToIdent(EventInfo.GestureID, S) then
  begin
   if s = 'sgiLeft' then LeftRightPanning.Execute;
   if s = 'sgiRight' then RightLeftPanning.Execute;
   if s = 'sgiDown' then TopDownPanning.Execute;
   if s = 'sgiUp' then DownTopPanning.Execute;
  end;
end;

procedure TSCalendar.EventsSButtonClick(Sender: TObject);
begin
  if not LeftPanel.Visible then
  begin
    LeftPanel.Visible := True;
    LeftPanel.BringToFront;
  end
  else
  begin
    LeftPanel.Visible := False;
    LeftPanel.SendToBack;
  end;
end;

procedure TSCalendar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //GoogleClient.SaveToFile('access.tmp');
end;

procedure TSCalendar.FormCreate(Sender: TObject);
begin
  GAccess := System.IOUtils.TPath.Combine(
  System.IOUtils.tpath.getdocumentspath,'access.tmp');
  if FileExists(GAccess) then
    GoogleClient.LoadFromFile(GAccess);
  CalendarList := TStringList.Create;
  EventList := TStringList.Create;
  //LoginPanel.Visible := True;
  LoginClick(Self);
  FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FormatSettings.DateSeparator := '-';
  FormatSettings.LongTimeFormat := 'HH:mm:ss';
  FormatSettings.TimeSeparator := ':';
end;

procedure TSCalendar.FormDestroy(Sender: TObject);
begin
  CalendarList.Free;
  EventList.Free;
end;

procedure TSCalendar.LeftRightPanningExecute(Sender: TObject);
begin
  if EventBox.ItemIndex > 0 then
   EventBox.ItemIndex := EventBox.ItemIndex - 1;
end;

procedure TSCalendar.LoginClick(Sender: TObject);
begin
  if not KeyEdit.Enabled then
    begin
    {$IFDEF WINDOWS}
      ShellExecute(0, 'open', PChar(GoogleClient.StartConnect), nil, nil, SW_SHOWNORMAL);
      KeyEdit.Enabled := True;
      Login.Text := 'Завершить авторизацию';
    {$ENDIF}
    {$IFDEF ANDROID}
      KeyEdit.Text:='here';
      WebBrowser.Url := GoogleClient.StartConnect;
      WebBrowser.Visible:=true;
      WebBrowser.BringToFront;
    {$ENDIF}
    end
  else
    begin
      KeyEdit.Enabled := False;
      Login.Text := 'Войти';
      try
        GoogleClient.EndConnect(KeyEdit.Text);
        Login.Enabled := False;
        UpdateCalendarMenu;
        LoginPanel.Visible:=False;
        ChCaPanel.Visible:=True;
      except
      end;
    end
end;

procedure TSCalendar.MainPanelClick(Sender: TObject);
begin
  //ChCaPanel.Visible := False;
  //LoginPanel.Visible := False;
end;

procedure TSCalendar.RefreshTokenTimerTimer(Sender: TObject);
begin
  try
    GoogleClient.RefreshToken;
  except
  end;
end;

procedure TSCalendar.RightLeftPanningExecute(Sender: TObject);
begin
 if EventBox.ItemIndex < (EventBox.Count - 1) then
   EventBox.ItemIndex := EventBox.ItemIndex + 1;
end;

procedure TSCalendar.ShowChCaPanel(ShowState: Boolean);
begin
  if ShowState then
    begin
      TimePanel.Visible := False;
      ShadowPanel.Visible := True;
      ChCaPanel.Visible := True;
    end
  else
    begin
      ShadowPanel.Visible := False;
      ChCaPanel.Visible := False;
    end;
end;

procedure TSCalendar.ShowTimer(ShowState: Boolean);
begin
  if ShowState then
    begin
      ChCaPanel.Visible := False;
      ShadowPanel.Visible := True;
      TimePanel.Visible := True;
      ToTimer.Enabled := True;
    end
  else
    begin
      ShadowPanel.Visible := False;
      TimePanel.Visible := False;
      ToTimer.Enabled := False;
    end;
end;

procedure TSCalendar.TimerSButtonClick(Sender: TObject);
begin
  if not TimePanel.Visible then
    ShowTimer(True)
  else
    ShowTimer(False);
end;

procedure TSCalendar.TopDownPanningExecute(Sender: TObject);
begin
 {if TimePanel.Visible then
 begin
  TimePanel.Visible := False;
  ToTimer.Enabled := False;
  TimePanel.SendToBack;
 end
 else
 begin
  ChCaPanel.Visible := True;
  ChCaPanel.BringToFront;
 end;}
end;

procedure TSCalendar.ToTimerTimer(Sender: TObject);
begin
  if EventBox.Selected <> nil then
  begin
   ToLabel.Text := 'To '+EventBox.Selected.Text;
   //EventBox.ItemIndex := 0;
   TimeLabel.Text := IntToStr(SecondsBetween(now,
   StrToDateTime(StartTimeEdit.Text, FormatSettings)) div 3600)
      + ' hours ' + IntToStr(SecondsBetween(now,
      StrToDateTime(StartTimeEdit.Text, FormatSettings)) mod 3600 div 60)
      + ' minutes ' + IntToStr(SecondsBetween(now,
      StrToDateTime(StartTimeEdit.Text, FormatSettings)) mod 3600 mod 60)
      + ' seconds';
  end;
end;

procedure TSCalendar.UpdateEventView;
var
  Response: TStringStream;
  JsonObject: ISuperObject;
  RequestString: String;
begin
  Response := TStringStream.Create;
  try
    RequestString := 'https://www.googleapis.com/calendar/v3/calendars/'+
      HttpEncode(CalendarList.Values[CalendarBox.Selected.Text])+'/events/'+
      HttpEncode(EventList.ValueFromIndex[EventBox.ItemIndex]);
    GoogleClient.Get(RequestString,Response);
    //Response.SaveToFile('eventget.json');
    JsonObject := SO(Response.DataString);
    SummaryLabel.Text := JsonObject.S['summary'];
    StartTimeEdit.Text := JsonObject.O['start'].S['dateTime'];
    EndTimeEdit.Text := JsonObject.O['end'].S['dateTime'];
    EventCheckDescription(JsonObject.S['description']);
    finally
      try
        Response.Free;
      except
      end;
    end;
end;

procedure TSCalendar.UpdateTimerTimer(Sender: TObject);
begin
  if EventBox.Count > 0 then
  begin
    try
     UpdateEventView;
    except
    end;
  end;
end;

procedure TSCalendar.UpdateCalendarMenu;
var
  Response: TStringStream;
  JSONArray: ISuperArray;
  JsonObject, CalendarInf: ISuperObject;
  i: Integer;
begin
  Response := TStringStream.Create;
  try
    GoogleClient.Get('https://www.googleapis.com/calendar/v3/users/me/calendarList',Response);
    //Response.SaveToFile('calendarlist.json');
    JsonObject := SO(Response.DataString);
    JSONArray := JsonObject['items'].AsArray;
    CalendarList.Clear;
    for I := 0 to JSONArray.Length-1 do
    begin
      CalendarInf := JSONArray.O[i];
      CalendarList.Add(CalendarInf.S['summary']+'='+CalendarInf.S['id']);
      CalendarBox.Items.Add(CalendarInf.S['summary']);
    end;
    finally
      try
        Response.Free;
      except
      end;
    end;
end;

function BuildRequest(AFilter: Integer): String;
var
  LocalN: TDateTime;
begin
  LocalN := TTimeZone.Local.ToUniversalTime(now);
  Result := 'https://www.googleapis.com/calendar/v3/calendars/'+
      HttpEncode(CalendarList.Values[SCalendar.CalendarBox.Selected.Text])
      +'/events?singleEvents=true&orderBy=startTime';
  case AFilter of
    0: Result := Result + '&timeMax=' + HttpEncode(
      FormatDateTime('yyyy-MM-dd',TTimeZone.Local.ToUniversalTime(LocalN))
      +'T16:00:00+00:00')+'&timeMin='+
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN) + 'T00:00:00+00:00');
    1: Result := Result + '&timeMax=' + HttpEncode(
      FormatDateTime('yyyy-MM-dd',TTimeZone.Local.ToUniversalTime(LocalN))
      +'T23:59:59+00:00')+'&timeMin='+ HttpEncode(
      FormatDateTime('yyyy-MM-dd',LocalN) + 'T16:00:00+00:00');
    2: Result := Result + '&timeMax=' +
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN+2)
      +'T00:00:00+00:00')+'&timeMin='+
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN+1) + 'T00:00:00+00:00');
    3: Result := Result + '&timeMax=' +
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN+5)
      +'T00:00:00+00:00')+'&timeMin='+
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN) + 'T00:00:00+00:00');
    4: Result := Result + '&timeMax=' +
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN+30)
      +'T00:00:00+00:00')+'&timeMin='+
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN) + 'T00:00:00+00:00');
    5: Result := Result + '&timeMin=' +
      HttpEncode(FormatDateTime('yyyy-MM-dd',LocalN) + 'T00:00:00+00:00');
  end;
end;

procedure TSCalendar.UpdateCalendarEvents(AFilter: Integer);
var
  Response: TStringStream;
  JSONArray: ISuperArray;
  JsonObject, EventInf: ISuperObject;
  i: Integer;
  RequestString: String;
begin
  Response := TStringStream.Create;
  try
    RequestString := BuildRequest(AFilter);
    //ShowMessage(RequestString);
    GoogleClient.Get(RequestString,Response);
    //Response.SaveToFile('eventlist.json');
    JsonObject := SO(Response.DataString);
    JSONArray := JsonObject['items'].AsArray;
    EventList.Clear;
    EventBox.Clear;
    for I := 0 to JSONArray.Length-1 do
    begin
      EventInf := JSONArray.O[i];
      EventList.Add(EventInf.S['summary']+'='+
        EventInf.S['id']);
      EventBox.Items.Add(EventInf.S['summary']);
    end;
    //RearrangeEvents;
    finally
      try
        Response.Free;
      except
      end;
    end;
end;

procedure TSCalendar.UpEventsButtonClick(Sender: TObject);
begin
  if (CalendarBox.Selected <> nil) and (FilterBox.Selected <> nil) then
  begin
    UpdateCalendarEvents(FilterBox.ItemIndex);
    ShowChCaPanel(False);
  end;
end;

procedure TSCalendar.WebBrowserShouldStartLoadWithRequest(ASender: TObject;
  const URL: string);
var
Fstr: String;
begin
  if URL.Contains('code=') then
  begin
    try
      FStr := URL.Substring(pos('code=',URL)+'code='.Length-1);
      //ShowMessage(FStr);
      GoogleClient.EndConnect(Fstr);
      //ShowMessage(DateToStr(GoogleClient.TokenInfo.ExpiresTime));
      Login.Enabled := False;
      WebBrowser.Visible := False;
      ShowChCaPanel(True);
      UpdateCalendarMenu;
      LoginPanel.Visible:=False;
      GoogleClient.SaveToFile(GAccess);
    except
    end;
  end;
end;


procedure TSCalendar.FormResize(Sender: TObject);
begin
  if ClientWidth > 450 then
    begin
      EventsSButton.Visible := False;
      MainPanel.Align := TAlignLayout.Client;
      LeftPanel.Visible := True;
    end
  else
    begin
      EventsSButton.Visible := True;
      MainPanel.Align := TAlignLayout.Contents;
      LeftPanel.Visible := False;
    end;
end;

end.
