// CodeGear C++Builder
// Copyright (c) 1995, 2014 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Google.OAuth.pas' rev: 28.00 (Android)

#ifndef Google_OauthHPP
#define Google_OauthHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.JSON.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit
#include <Data.DBXJSON.hpp>	// Pascal unit
#include <Data.DBXPlatform.hpp>	// Pascal unit
#include <IdHTTP.hpp>	// Pascal unit
#include <IdURI.hpp>	// Pascal unit
#include <IdSSLOpenSSL.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.Generics.Collections.hpp>	// Pascal unit
#include <System.Generics.Defaults.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Google
{
namespace Oauth
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EOAuthException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EOAuthException : public Idhttp::EIdHTTPProtocolException
{
	typedef Idhttp::EIdHTTPProtocolException inherited;
	
private:
	System::UnicodeString FServerMessage;
	System::UnicodeString FDomain;
	System::UnicodeString FReason;
	System::UnicodeString FLocationType;
	System::UnicodeString FLocation;
	void __fastcall Parse(void);
	
public:
	__fastcall virtual EOAuthException(const int anErrCode, const System::UnicodeString asReplyMessage, const System::UnicodeString asErrorMessage);
	__property System::UnicodeString ServerMessage = {read=FServerMessage};
	__property System::UnicodeString Domain = {read=FDomain};
	__property System::UnicodeString Reason = {read=FReason};
	__property System::UnicodeString LocationType = {read=FLocationType};
	__property System::UnicodeString Location = {read=FLocation};
public:
	/* EIdException.Create */ inline __fastcall virtual EOAuthException(const System::UnicodeString AMsg)/* overload */ : Idhttp::EIdHTTPProtocolException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EOAuthException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High) : Idhttp::EIdHTTPProtocolException(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EOAuthException(System::PResStringRec ResStringRec) : Idhttp::EIdHTTPProtocolException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EOAuthException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High) : Idhttp::EIdHTTPProtocolException(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EOAuthException(const System::UnicodeString Msg, int AHelpContext) : Idhttp::EIdHTTPProtocolException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EOAuthException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_High, int AHelpContext) : Idhttp::EIdHTTPProtocolException(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EOAuthException(System::PResStringRec ResStringRec, int AHelpContext) : Idhttp::EIdHTTPProtocolException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EOAuthException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_High, int AHelpContext) : Idhttp::EIdHTTPProtocolException(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EOAuthException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TScopes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TScopes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FFullAccess;
	bool FReadonly;
	
protected:
	System::Classes::TStrings* FScopes;
	virtual System::Classes::TStrings* __fastcall GetScopes(void);
	virtual System::UnicodeString __fastcall GetAuthPrefix(void);
	virtual void __fastcall SetupScope(const System::UnicodeString AScopeValue);
	
public:
	__fastcall TScopes(void);
	__fastcall virtual ~TScopes(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Classes::TStrings* Scopes = {read=GetScopes};
	
__published:
	__property bool FullAccess = {read=FFullAccess, write=FFullAccess, nodefault};
	__property bool Readonly = {read=FReadonly, write=FReadonly, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TDriveScopes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TDriveScopes : public TScopes
{
	typedef TScopes inherited;
	
private:
	typedef System::StaticArray<System::UnicodeString, 5> _TDriveScopes__1;
	
	
private:
	static _TDriveScopes__1 cScopeValues;
	bool FFileAccess;
	bool FAppsReadonly;
	bool FReadonlyMetadata;
	bool FInstall;
	bool FAppdata;
	
protected:
	virtual System::Classes::TStrings* __fastcall GetScopes(void);
	virtual System::UnicodeString __fastcall GetAuthPrefix(void);
	virtual void __fastcall SetupScope(const System::UnicodeString AScopeValue);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property FullAccess;
	__property Readonly;
	__property bool FileAccess = {read=FFileAccess, write=FFileAccess, nodefault};
	__property bool AppsReadonly = {read=FAppsReadonly, write=FAppsReadonly, nodefault};
	__property bool ReadonlyMetadata = {read=FReadonlyMetadata, write=FReadonlyMetadata, nodefault};
	__property bool Install = {read=FInstall, write=FInstall, nodefault};
	__property bool Appdata = {read=FAppdata, write=FAppdata, nodefault};
public:
	/* TScopes.Create */ inline __fastcall TDriveScopes(void) : TScopes() { }
	/* TScopes.Destroy */ inline __fastcall virtual ~TDriveScopes(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TCalendarScopes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCalendarScopes : public TScopes
{
	typedef TScopes inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetAuthPrefix(void);
public:
	/* TScopes.Create */ inline __fastcall TCalendarScopes(void) : TScopes() { }
	/* TScopes.Destroy */ inline __fastcall virtual ~TCalendarScopes(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TTasksScopes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TTasksScopes : public TScopes
{
	typedef TScopes inherited;
	
protected:
	virtual System::UnicodeString __fastcall GetAuthPrefix(void);
public:
	/* TScopes.Create */ inline __fastcall TTasksScopes(void) : TScopes() { }
	/* TScopes.Destroy */ inline __fastcall virtual ~TTasksScopes(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TCustomTokenInfo;
class PASCALIMPLEMENTATION TCustomTokenInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FAudience;
	System::TDateTime FExpiresTime;
	System::UnicodeString FAccessToken;
	System::UnicodeString FRefreshToken;
	System::UnicodeString FTokenType;
	System::Classes::TStrings* FScopes;
	TDriveScopes* FDriveScopes;
	TCalendarScopes* FCalendarScopes;
	TTasksScopes* FTasksScopes;
	System::UnicodeString __fastcall GetScopeStr(void);
	void __fastcall SetScopes(System::Classes::TStrings* AScopes);
	void __fastcall SetDriveScopes(TDriveScopes* ADriveScopes);
	void __fastcall SetCalendarScopes(TCalendarScopes* ACalendarScopes);
	void __fastcall SetTasksScopes(TTasksScopes* ATaskScopes);
	System::UnicodeString __fastcall GetJSON(void);
	
public:
	__fastcall TCustomTokenInfo(void);
	__fastcall virtual ~TCustomTokenInfo(void);
	void __fastcall Revoke(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Parse(const System::UnicodeString AJSONString);
	__property System::UnicodeString AccessToken = {read=FAccessToken};
	__property System::UnicodeString RefreshToken = {read=FRefreshToken};
	__property System::UnicodeString TokenType = {read=FTokenType};
	__property System::TDateTime ExpiresTime = {read=FExpiresTime};
	__property System::UnicodeString ScopeParam = {read=GetScopeStr};
	__property System::UnicodeString Audience = {read=FAudience, write=FAudience};
	__property System::UnicodeString JSON = {read=GetJSON};
	
__published:
	__property TDriveScopes* DriveScopes = {read=FDriveScopes, write=SetDriveScopes};
	__property TCalendarScopes* CalendarScopes = {read=FCalendarScopes, write=SetCalendarScopes};
	__property TTasksScopes* TasksScopes = {read=FTasksScopes, write=SetTasksScopes};
	__property System::Classes::TStrings* CustomScopes = {read=FScopes, write=SetScopes};
};


class DELPHICLASS TTokenInfo;
class PASCALIMPLEMENTATION TTokenInfo : public TCustomTokenInfo
{
	typedef TCustomTokenInfo inherited;
	
public:
	__property AccessToken = {default=0};
	__property RefreshToken = {default=0};
	__property TokenType = {default=0};
	__property ExpiresTime = {default=0};
	__property ScopeParam = {default=0};
	__property Audience = {default=0};
	__property JSON = {default=0};
	
__published:
	__property DriveScopes;
	__property CalendarScopes;
	__property TasksScopes;
	__property CustomScopes;
public:
	/* TCustomTokenInfo.Create */ inline __fastcall TTokenInfo(void) : TCustomTokenInfo() { }
	/* TCustomTokenInfo.Destroy */ inline __fastcall virtual ~TTokenInfo(void) { }
	
};


typedef void __fastcall (__closure *TOnGetToken)(TCustomTokenInfo* const ATokenInfo);

enum DECLSPEC_DENUM TSaveFields : unsigned char { sfClientSecret, sfRedirectURI, sfState, sfLoginHint };

typedef System::Set<TSaveFields, TSaveFields::sfClientSecret, TSaveFields::sfLoginHint> TSaveFieldsSet;

enum DECLSPEC_DENUM TDefaultContentType : unsigned char { ctJSON, ctXML };

class DELPHICLASS TOAuthClient;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOAuthClient : public Fmx::Types::TFmxObject
{
	typedef Fmx::Types::TFmxObject inherited;
	
private:
	Idhttp::TIdHTTP* FHTTPClient;
	Idsslopenssl::TIdSSLIOHandlerSocketOpenSSL* FSSLIOHandler;
	System::UnicodeString FRedirectURI;
	System::UnicodeString FClientSecret;
	TCustomTokenInfo* FTokenInfo;
	System::UnicodeString FState;
	System::UnicodeString FLoginHint;
	bool FOpenStartURL;
	bool FValidateOnLoad;
	TSaveFieldsSet FSaveFields;
	TOnGetToken FOnGetToken;
	TDefaultContentType FDefaultContentType;
	System::Classes::TNotifyEvent FOnDisconnect;
	System::Classes::TNotifyEvent FOnSave;
	System::Classes::TNotifyEvent FOnLoad;
	System::Classes::TNotifyEvent FOnValidateError;
	System::Classes::TNotifyEvent FOnValidateComplete;
	void __fastcall OpenURL(const System::UnicodeString AURL);
	void __fastcall RaiseError(System::Sysutils::Exception* E, const System::UnicodeString ACustomMessage = System::UnicodeString());
	System::UnicodeString __fastcall GetStartURL(void);
	void __fastcall SetTokenInfo(TCustomTokenInfo* ATokenInfo);
	void __fastcall DoOnGetToken(void);
	void __fastcall DoOnLoad(void);
	System::UnicodeString __fastcall GetClientID(void);
	void __fastcall SetClientID(const System::UnicodeString AAudience);
	void __fastcall SetHeaders(const System::UnicodeString AMimeType = System::UnicodeString(), bool NeedContentType = true);
	
public:
	__fastcall virtual TOAuthClient(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOAuthClient(void);
	System::UnicodeString __fastcall StartConnect(void);
	void __fastcall EndConnect(const System::UnicodeString ACode);
	void __fastcall RefreshToken(void);
	void __fastcall Disconnect(void);
	bool __fastcall OnlineValidate(void);
	void __fastcall SaveToFile(const System::UnicodeString AFileName);
	void __fastcall LoadFromFile(const System::UnicodeString AFileName);
	void __fastcall Get(const System::UnicodeString AURL, System::Classes::TStream* AResponseStream);
	void __fastcall Post(const System::UnicodeString AURL, System::Classes::TStream* ASourceStream, System::Classes::TStream* AResponseStream)/* overload */;
	void __fastcall Post(const System::UnicodeString AURL, const System::UnicodeString AContentType, System::Classes::TStream* ASourceStream, System::Classes::TStream* AResponseStream)/* overload */;
	void __fastcall Delete(const System::UnicodeString AURL)/* overload */;
	void __fastcall Put(const System::UnicodeString AURL, System::Classes::TStream* ASourceStream, System::Classes::TStream* AResponseStream)/* overload */;
	void __fastcall Put(const System::UnicodeString AURL, const System::UnicodeString AContentType, System::Classes::TStream* ASourceStream, System::Classes::TStream* AResponseStream)/* overload */;
	
__published:
	__property System::UnicodeString RedirectURI = {read=FRedirectURI, write=FRedirectURI};
	__property System::UnicodeString ClientID = {read=GetClientID, write=SetClientID};
	__property System::UnicodeString ClientSecret = {read=FClientSecret, write=FClientSecret};
	__property System::UnicodeString State = {read=FState, write=FState};
	__property System::UnicodeString LoginHint = {read=FLoginHint, write=FLoginHint};
	__property TCustomTokenInfo* TokenInfo = {read=FTokenInfo, write=SetTokenInfo};
	__property TSaveFieldsSet SaveFields = {read=FSaveFields, write=FSaveFields, nodefault};
	__property TDefaultContentType DefaultContentType = {read=FDefaultContentType, write=FDefaultContentType, nodefault};
	__property bool ValidateOnLoad = {read=FValidateOnLoad, write=FValidateOnLoad, nodefault};
	__property bool OpenStartURL = {read=FOpenStartURL, write=FOpenStartURL, nodefault};
	__property TOnGetToken OnGetToken = {read=FOnGetToken, write=FOnGetToken};
	__property System::Classes::TNotifyEvent OnDisconnect = {read=FOnDisconnect, write=FOnDisconnect};
	__property System::Classes::TNotifyEvent OnSave = {read=FOnSave, write=FOnSave};
	__property System::Classes::TNotifyEvent OnLoad = {read=FOnLoad, write=FOnLoad};
	__property System::Classes::TNotifyEvent OnValidateError = {read=FOnValidateError, write=FOnValidateError};
	__property System::Classes::TNotifyEvent OnValidateComplete = {read=FOnValidateComplete, write=FOnValidateComplete};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Oauth */
}	/* namespace Google */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GOOGLE_OAUTH)
using namespace Google::Oauth;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GOOGLE)
using namespace Google;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Google_OauthHPP
