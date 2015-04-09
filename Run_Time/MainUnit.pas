unit MainUnit;

interface

uses
  System.SysUtils, System.JSON, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Google.OAuth, HttpApp,DateUtils,
  FMX.StdCtrls, System.Actions, FMX.ActnList, FMX.Menus, FMX.Layouts, XSuperJson, XSuperObject,
  FMX.Gestures, FMX.Controls.Presentation, FMX.Edit, FMX.ListBox,
  FMX.DateTimeCtrls, System.IOUtils, FMX.WebBrowser, FMX.Calendar, FMX.ListView.Types,
  FMX.ListView, FMX.Objects, FMX.TabControl, EventTabUnit, DayUnit;

type
  TSCalendar = class(TForm)
    GoogleClient: TOAuthClient;
    RefreshTokenTimer: TTimer;
    MainPanel: TPanel;
    ToTimer: TTimer;
    MenuPanel: TPanel;
    StyleBook1: TStyleBook;
    SettingsPanel: TPanel;
    CalendarBox: TComboBox;
    OkButton: TButton;
    OptionsButton: TSpeedButton;
    ChooseCalendarLabel: TLabel;
    DateLabel: TLabel;
    MainTabControl: TTabControl;
    BrendLabel: TLabel;
    EventTab: TTabItem;
    DayTab: TTabItem;
    WeekTab: TTabItem;
    WeekPeriodLabel: TLabel;
    DayPeriodLabel: TLabel;
    DaysScrollBox: TFramedVertScrollBox;
    EventsBox: TListBox;
    SettingsTab: TTabItem;
    ButtonPanel: TPanel;
    ProfileBox: TComboBox;
    GradeBox: TComboBox;
    BackButton: TButton;
    UpdateButton: TButton;
    EventTabFrame: TEventTabFrame;
    procedure FormCreate(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RefreshTokenTimerTimer(Sender: TObject);
    procedure ToTimerTimer(Sender: TObject);
    procedure OptionsButtonClick(Sender: TObject);
    procedure CalendarBoxChange(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure EventsBoxItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure UpdateButtonClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure UpdateCalendarMenu;
    procedure UpdateCalendarEvents(AStartDay, AEndDay: TDate);
    procedure SaveOptions;
    procedure InitOptions;
    function ExtractGradeFromName(AName: String): String;
    procedure LoadWeekRepresentation;
    procedure LoadEventRepresentation(EventN: Integer; ADay: TDate);
    function ClearDescFromTag(ADescription: String): String;
    function GetValueFromDescription(ADescription,AName: String): String;
    procedure LoadDayRepresentation(ADay: TDate);
    procedure DayClick(Sender: TObject);
  public
    { Public declarations }
  end;
    function BuildRequest(AStartDay, AEndDay: TDate): String;
    function ReplaceAllChars(ASource: String; AChar, ChChar: Char): String;
var
  SCalendar: TSCalendar;
  CalendarList, OptionList: TStringList;
  EventsArray: ISuperArray;
  FormatSettings: TFormatSettings;
  GOptions: String;
  DayFrames: array [0..6] of TDayFrame;
implementation

{$R *.fmx}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}

//timer never started
//hide back button while setting options

function ReplaceAllChars(ASource: String; AChar, ChChar: Char): String;
begin
  Result := ASource;
  while Result.Contains(AChar) do
    Result := Result.Replace(AChar, ChChar);
end;

procedure TSCalendar.BackButtonClick(Sender: TObject);
begin
  if BackButton.Visible then
    if BackButton.Text = 'Week' then
    begin
      Application.ProcessMessages;
      LoadWeekRepresentation;
      MainTabControl.ActiveTab := MainTabControl.Tabs[0];
      BackButton.Visible := False;
    end
    else
    begin
      Application.ProcessMessages;
      LoadDayRepresentation(StrToDate(DayPeriodLabel.Text));
      MainTabControl.ActiveTab := MainTabControl.Tabs[1];
      BackButton.Text := 'Week';
      ToTimer.Enabled := False;
    end;
end;

procedure TSCalendar.CalendarBoxChange(Sender: TObject);
begin
  if CalendarBox.Selected.Text.Contains('SC') then
  begin
    ProfileBox.Enabled := True;
    GradeBox.Enabled := True;
  end
  else
  begin
    ProfileBox.Enabled := False;
    GradeBox.Enabled := False;
  end;
end;

function TSCalendar.ClearDescFromTag(ADescription: String): String;
var
  stpos: Integer;
begin
  if ADescription.Contains('#lesson') then
  begin
    stpos := pos('#lesson',ADescription);
    ADescription := ADescription.Remove(stpos-1,'#lesson'.Length);
  end;
  Result := ADescription;
end;

procedure TSCalendar.DayClick(Sender: TObject);
var
  DayDate: TDate;
begin
  DayDate := StrToDate((((Sender as TfmxObject).Parent.Parent) as TDayFrame).DayPeriodLabel.Text);
  LoadDayRepresentation(DayDate);
  MainTabControl.ActiveTab := MainTabControl.Tabs[1];
  BackButton.Text := 'Week';
  BackButton.Visible := True;
end;

procedure TSCalendar.EventsBoxItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  Application.ProcessMessages;
  LoadEventRepresentation(Item.Index,StrToDate(DayPeriodLabel.Text));
  BackButton.Text := 'Day';
  BackButton.Visible := True;
  MainTabControl.ActiveTab := MainTabControl.Tabs[2];
end;

function TSCalendar.ExtractGradeFromName(AName: String): String;
begin
  Result := AName.Substring(AName.IndexOf('/')+1)
end;

procedure TSCalendar.FormCreate(Sender: TObject);
begin
  GOptions := System.IOUtils.TPath.Combine(
  System.IOUtils.tpath.getdocumentspath,'options.ini');
  CalendarList := TStringList.Create;
  FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FormatSettings.DateSeparator := '-';
  FormatSettings.LongTimeFormat := 'HH:mm:ss';
  FormatSettings.TimeSeparator := ':';
  DateLabel.Text := DateToStr(today);
  GoogleClient.TokenInfo.RefreshToken := '1/-YBnK9J1HfP2t6v1Yv19ji32sPDAJQLCZL7Rn5MD23gMEudVrK5jSpoR30zcRFq6';
  try
    GoogleClient.RefreshToken;
  except
    ShowMessage('Lost internet connection.'
      + ' Please check your connection and open app again.');
    SCalendar.Close;
  end;
  InitOptions;
end;

procedure TSCalendar.FormDestroy(Sender: TObject);
begin
  CalendarList.Free;
  OptionList.Free;
end;

procedure TSCalendar.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    vkHardwareBack: begin
      BackButtonClick(Self);
      Key := 0;
    end;
    vkMenu: begin
      BackButton.Visible := False;
      MainTabControl.ActiveTab := MainTabControl.Tabs[3];
    end;
  end;
end;

function TSCalendar.GetValueFromDescription(ADescription,
  AName: String): String;
var
  X: ISuperObject;
begin
  try
    X := SO(ReplaceAllChars(ADescription,';',','));
    Result := X.S[AName];
  except
    Result := '';
  end;
end;

procedure TSCalendar.InitOptions;
begin
  OptionList := TStringList.Create;
  if FileExists(GOptions) then
  begin
    try
      OptionList.LoadFromFile(GOptions);
      UpdateCalendarMenu;
      CalendarBox.ItemIndex := StrToInt(OptionList.Values['CalendarIndex']);
      if CalendarBox.Selected.Text.Contains('SC') then
      begin
        ProfileBox.ItemIndex := StrToInt(OptionList.Values['MajorIndex']);
        GradeBox.ItemIndex := StrToInt(OptionList.Values['GradeIndex']);
      end;
      UpdateCalendarEvents(today,today+6);
      LoadDayRepresentation(today);
      BackButton.Text := 'Week';
      BackButton.Visible := True;
      MainTabControl.ActiveTab := MainTabControl.Tabs[1];
    except
      UpdateCalendarMenu;
      MainTabControl.ActiveTab := MainTabControl.Tabs[3];
    end;
  end
  else
  begin
    UpdateCalendarMenu;
    MainTabControl.ActiveTab := MainTabControl.Tabs[3];
  end;
end;

procedure TSCalendar.LoadDayRepresentation(ADay: TDate);
var
  i, ind: Integer;
  EventObject, StartObject: ISuperObject;
  desc: String;
begin
  EventsBox.Clear;
  //UpdateCalendarEvents(today,today+6);
  DayPeriodLabel.Text := DateToStr(ADay);
  //ShowMessage(EventsArray.AsJSON);
  for i := 0 to EventsArray.Length-1 do
    begin
      try
        EventObject := EventsArray.O[i];
        StartObject := EventObject.O['start'];
        desc := StartObject.AsJSON;
        if Trunc(StrToDateTime(StartObject.S['dateTime'],FormatSettings))=ADay then
        begin
          ind := EventsBox.Items.Add(EventObject.S['summary']);
          desc := EventObject.S['description'];
          if desc.Contains('#lesson') then
            EventsBox.Items[ind] := EventsBox.Items[ind]+'  '+
              GetValueFromDescription(ClearDescFromTag(desc),'room')+'  '+
              GetValueFromDescription(ClearDescFromTag(desc),'teacher')
        end;
      except
      end;
    end;
    SCalendar.UpdateActions;
end;

procedure TSCalendar.LoadEventRepresentation(EventN: Integer; ADay: TDate);
var
  EventObject, StartObject, EndObject: ISuperObject;
  desc: String;
  i: Integer;
begin
  i:=0;
  EventObject := EventsArray.O[i];
  StartObject := EventObject.O['start'];
  while Trunc(StrToDateTime(StartObject.S['dateTime'],FormatSettings))<ADay do
  begin
    i := i + 1;
    EventObject := EventsArray.O[i];
    StartObject := EventObject.O['start'];
  end;
  EventObject := EventsArray.O[i+EventN];
  StartObject := EventObject.O['start'];
  EventTabFrame.StartTimeEdit.Text := StartObject.S['dateTime'];
  EndObject := EventObject.O['end'];
  EventTabFrame.EndTimeEdit.Text := EndObject.S['dateTime'];
  EventTabFrame.SummaryLabel.Text := EventObject.S['summary'];
  desc := EventObject.S['description'];
  if desc.Contains('#lesson') then
  begin
    EventTabFrame.LessonPanel.Visible := True;
    desc := ClearDescFromTag(desc);
    EventTabFrame.RoomEdit.Text := GetValueFromDescription(desc,'room');
    EventTabFrame.TeacherEdit.Text := GetValueFromDescription(desc,'teacher');
  end;
  ToTimer.Enabled := True;
  SCalendar.UpdateActions;
end;


procedure TSCalendar.LoadWeekRepresentation;
var
  i, i1, ind, StartY: Integer;
  DayDate: TDate;
  EventObject, StartObject: ISuperObject;
  desc: String;
begin
  //UpdateCalendarEvents(today,today+6);
  StartY := 0;
  for i := 0 to 6 do
  begin
    DayDate := today + i;
    if DayFrames[i] = nil then
    begin
      DayFrames[i] := TDayFrame.Create(DaysScrollBox);
      DayFrames[i].Name := 'DayFrame'+IntToStr(i);
      DayFrames[i].Parent := DaysScrollBox;
      DayFrames[i].Position.Y := StartY;
      DayFrames[i].Position.X := 0;
      DayFrames[i].Width := DaysScrollBox.Width;
      DayFrames[i].DetailsButton.OnClick := DayClick;
      DayFrames[i].DayPeriodLabel.Text := DateToStr(DayDate);
    end;
    DayFrames[i].EventsBox.Clear;
    for i1 := 0 to EventsArray.Length-1 do
    begin
      try
        EventObject := EventsArray.O[i1];
        StartObject := EventObject.O['start'];
        if Trunc(StrToDateTime(StartObject.S['dateTime'],FormatSettings))=DayDate then
        begin
          ind := DayFrames[i].EventsBox.Items.Add(EventObject.S['summary']);
          desc := EventObject.S['description'];
          if desc.Contains('#lesson') then
            DayFrames[i].EventsBox.Items[ind] := DayFrames[i].EventsBox.Items[ind]+'  '+
              GetValueFromDescription(ClearDescFromTag(desc),'room')
        end;
      except
      end;
    end;
    DayFrames[i].Height := 103+DayFrames[i].EventsBox.Count*DayFrames[i].EventsBox.ItemHeight;
    StartY := StartY + Trunc(DayFrames[i].Height);
  end;
  WeekPeriodLabel.Text := DateToStr(today)+' - '+DateToStr(today+6);
  SCalendar.UpdateActions;
end;

procedure TSCalendar.RefreshTokenTimerTimer(Sender: TObject);
begin
  try
    GoogleClient.RefreshToken;
  except
  end;
end;


procedure TSCalendar.SaveOptions;
var
  ADay: TDate;
begin
  BackButton.Text := 'Week';
  BackButton.Visible := True;
  ADay := today;
  UpdateCalendarEvents(today,today+6);
  LoadDayRepresentation(ADay);
  MainTabControl.ActiveTab := MainTabControl.Tabs[1];
  if OptionList = nil then
    OptionList := TStringList.Create;
  OptionList.Clear;
  OptionList.Add('CalendarIndex='+IntToStr(CalendarBox.ItemIndex));
  OptionList.Add('MajorIndex='+IntToStr(ProfileBox.ItemIndex));
  OptionList.Add('GradeIndex='+IntToStr(GradeBox.ItemIndex));
  OptionList.SaveToFile(GOptions);
end;

procedure TSCalendar.ToTimerTimer(Sender: TObject);
begin
  try
    if now<StrToDateTime(EventTabFrame.StartTimeEdit.Text, FormatSettings) then
    begin
      EventTabFrame.TimeLeftEdit.Text := IntToStr(SecondsBetween(now,
        StrToDateTime(EventTabFrame.StartTimeEdit.Text, FormatSettings)) div 3600)
        + ':' + IntToStr(SecondsBetween(now,
        StrToDateTime(EventTabFrame.StartTimeEdit.Text, FormatSettings)) mod 3600 div 60)
        + ':' + IntToStr(SecondsBetween(now,
        StrToDateTime(EventTabFrame.StartTimeEdit.Text, FormatSettings)) mod 3600 mod 60);
    end
    else
     EventTabFrame.TimeLeftEdit.Text := '-';
  except
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
    CalendarBox.Clear;
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

function BuildRequest(AStartDay, AEndDay: TDate): String;
begin
  Result := 'https://www.googleapis.com/calendar/v3/calendars/'+
      HttpEncode(CalendarList.Values[SCalendar.CalendarBox.Selected.Text])
      +'/events?singleEvents=true&orderBy=startTime';
  Result := Result + '&timeMax=' + HttpEncode(
      FormatDateTime('yyyy-MM-dd',AEndDay)
      +'T23:59:59+00:00')+'&timeMin='+
      HttpEncode(FormatDateTime('yyyy-MM-dd',AStartDay) + 'T00:00:00+00:00');
end;

procedure TSCalendar.UpdateButtonClick(Sender: TObject);
begin
  try
    UpdateCalendarEvents(today,today+6);
  except
  end;
end;

procedure TSCalendar.UpdateCalendarEvents(AStartDay, AEndDay: TDate);
var
  Response: TStringStream;
  JSONArray: ISuperArray;
  JsonObject, EventInf, DescriptionObject: ISuperObject;
  stpos: Integer;
  i: Integer;
  RequestString, EventInfStr: String;
begin
  Response := TStringStream.Create;
  try
    RequestString := BuildRequest(AStartDay, AEndDay);
    //ShowMessage(RequestString);
    GoogleClient.Get(RequestString,Response);
    JsonObject := SO(Response.DataString);
    JSONArray := JsonObject['items'].AsArray;
    for I := 0 to JSONArray.Length-1 do
    begin
      EventInf := JSONArray.O[i];
      EventInfStr := EventInf.S['description'];
      if EventInfStr.Contains('#lesson') and CalendarBox.Selected.Text.Contains('SC') then
      begin
        try
          stpos := pos('#lesson',EventInfStr);
          EventInfStr := EventInfStr.Remove(stpos-1,'#lesson'.Length);
          EventInfStr := ReplaceAllChars(EventInfStr,';',',');
          DescriptionObject := SO(EventInfStr);
          if (DescriptionObject.S['grade'] <> (ExtractGradeFromName(CalendarBox.Selected.Text)
          +GradeBox.Selected.Text)) or
          (DescriptionObject.S['major'] <> ProfileBox.Selected.Text) then
            JSONArray.Delete(i);
        except
          JSONArray.Delete(i);
        end;
      end;
    end;
    EventsArray := SA(JSONArray.AsJson);
  finally
    try
      Response.Free;
    except
    end;
  end;
end;

procedure TSCalendar.OkButtonClick(Sender: TObject);
begin
  if CalendarBox.ItemIndex > -1 then
  begin
    if CalendarBox.Selected.Text.Contains('SC') then
    begin
      if (GradeBox.ItemIndex > -1) and (ProfileBox.ItemIndex > -1) then
        SaveOptions
    end
    else
      SaveOptions;
  end;
end;

procedure TSCalendar.OptionsButtonClick(Sender: TObject);
begin
  //UpdateCalendarMenu;
  MainTabControl.ActiveTab := MainTabControl.Tabs[3];
  BackButton.Visible := False;
end;

end.
