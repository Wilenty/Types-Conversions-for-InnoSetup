//***************************************************************************************************
//    If my work helped you in any way please support me on:
//          https://www.buymeacoffee.com/Wilenty
//                      or on:
//            https://www.patreon.com/Wilenty
//
//***************************************************************************************************

#define test="TypesConversions4Test"

[Setup]
AppName={#test}
AppVersion=0.1
AppVerName={#test} by Wilenty
Uninstallable=no
PrivilegesRequired=lowest
CreateAppDir=False
OutputDir=.
OutputBaseFilename={#test}

#Include "TypesConversions4InnoSetup.isi"

[code]
Function MessageBoxA(hWnd: HWND; lpText: LPCSTR; lpCaption: LPCSTR; uType: UINT): Integer;
  External 'MessageBoxA@User32.dll stdcall';

#if defined Unicode
Function MessageBoxW(hWnd: HWND; lpText: LPCWSTR; lpCaption: LPCWSTR; uType: UINT): Integer;
  External 'MessageBoxW@User32.dll stdcall';

function GetCommandLineW: LPWSTR;
  External 'GetCommandLineW@kernel32.dll stdcall';
#EndIf

//(*
Const
  MB_ICONINFORMATION = $00000040;
//*)

Function InitializeSetup(): Boolean;
  Var
    PaString: PAnsiString;
    aString: AnsiString;
#if defined Unicode
    PwChar: PWideChar;
    PwString: PWideString;
    wString: WideString;
#EndIf
  begin
    aString := 'Wilenty''s Coversions Tests'#0;
    MsgBox('Before conversions: ' + aString, mbInformation, MB_OK);
    // Before first use, you must initiate the Pointer:
    PaString := AnsiString2PAnsiString(aString);
    // ^ Note, please don't call like this: AnsiString2PAnsiString(''); because you will see an error *
    aString := PAnsiString2AnsiString(PaString);
    With TMainForm.Create(nil) do
    begin
      MessageBoxA(Handle, 'Ansi result: ' + aString, 'MessageBoxA', MB_ICONINFORMATION);
      Free;
    end;
#if defined Unicode
    // Before first use, you must initiate the Pointer:
    PwChar := WideString2PWideChar( WideString(aString) );
    // ^ Note, please don't call like this: WideString2PWideChar(''); because you will see an error *
    wString := PWideChar2WideString(PwChar);
    // Before first use, you must initiate the Pointer:
    PwString := WideString2PWideString(wString);
    // ^ Note, please don't call like this: WideString2PWideString(''); because you will see an error *
    wString := PWideString2WideString(PwString);
    With TMainForm.Create(nil) do
    begin
      MessageBoxW(Handle, WideString2PWideChar('Unicode result: ' + wString), WideString2PWideChar('MessageBoxW'), MB_ICONINFORMATION);
      MessageBoxW(Handle, WideString2PWideChar( 'GetCommandLineW: ' + PWideChar2WideString( GetCommandLineW() ) ), WideString2PWideChar('MessageBoxW'), MB_ICONINFORMATION);
      Free;
    end;
    Result := True;
#EndIf
end;

#if defined Unicode
function GetWindowTextLengthW(hWnd: HWND): Integer;
  External 'GetWindowTextLengthW@User32.dll stdcall';

function GetWindowTextW(hWnd: HWND; lpString: LPWSTR; nMaxCount: Integer): Integer;
  External 'GetWindowTextW@User32.dll stdcall';
#EndIf

Procedure InitializeWizard();
  Var
    PwChar: PWideChar;
  begin
    With WizardForm do
    begin
      // Before first use, you must initiate the Pointer:
      PwChar := WideString2PWideChar(#0);
      // ^ Note, please don't call like this: WideString2PWideChar(''); because you will see an error *
      // and now you can use it...
      SetLength4PWideChar( PwChar, GetWindowTextLengthW(Handle)+1 );
      // ^ Note, please don't call like this: SetLength4PWideChar( PwChar, 0 ); because you will see an error *
      // * please use the: PwChar := WideString2PWideChar(#0); instead, if you want to reset the content *
      GetWindowTextW( Handle, PwChar, PWideChar4Length(PwChar) );
      If Not CheckPWideChar4NIL(PwChar) then
        MessageBoxW(Handle, WideString2PWideChar('GetWindowTextW: ' + PWideChar2WideString(PwChar)), WideString2PWideChar('MessageBoxW'), MB_ICONINFORMATION);
    end;
    Abort;
end;
