::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: サクラエディタ Grep & Replace - encoding: SJIS
::
::   sakura-gr Grepオプション "置換前" "置換後" "ファイル" "フォルダ"
::
:: (example)
::   sakura-gr SU "●" "★" "*.txt" ".\child"
::   sakura-gr N "●" "" "*.txt" ".\space folder"
::
:: 第１引数: Grepオプション
::   S - サブフォルダからも検索
::   L - 大文字と小文字を区別
::   R - 正規表現
::   P - 該当行を出力／未指定時は該当部分だけ出力
::   W - 単語単位で探す
::   U - 自動的に閉じる
::   N - なし
::
:: http://sakura.qp.land.to/?cmd=read&page=History%2F2.2.0.1
:: ※2.2.0.1には以下のバグがあります
::   - 正規表現のGrep置換で行内の1つめしか置換されない
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
setlocal enabledelayedexpansion
set PATH=C:\Windows\System32
set PATH=%PATH%;C:\Program Files\sakura;C:\Program Files (x86)\sakura;
set OPT=%1
set SRCH_STR=%2
set REPR_STR=%3
set FILE_PTN=%4
set FOLD_PTN=%5

:: 引数チェック（アスタリスクの使用が引数に想定されるため %* カウント方式が無効）
if     "%~1"=="" goto INVALID_ARG
if     "%~2"=="" goto INVALID_ARG
::     "%~3"=="" ※ブランク指定による文字削除を許可
if     "%~4"=="" goto INVALID_ARG
if     "%~5"=="" goto INVALID_ARG
if not "%~6"=="" goto INVALID_ARG

:: オプション N の処理
if "%OPT%"=="N" (set OPT=)

:: ダブルクォーテーション強制
if not %FILE_PTN:~0,1%%FILE_PTN:~-1% == "" goto DQ_REQUIRED
if not %FOLD_PTN:~0,1%%FOLD_PTN:~-1% == "" goto DQ_REQUIRED

:: サクラエディタ 既存プロセス確認
set TASK=""
for /f "delims=" %%A in ('tasklist ^| find /C "sakura.exe"') do set TASK=%%A
if %TASK% GTR 0 (
  echo.
  echo sakura-gr:
  echo   既にサクラエディタが開いています。すべて閉じてから実行してください。
  echo   連続して使う場合は事前に sakura-gr を引数無しで呼び出し、共通設定
  echo   にて「タスクトレイを使う」のチェックを外してください。
  echo.
  goto OVER
)

call sakura -SX=700 -SY=500 -GREPMODE -GKEY=%SRCH_STR% -GREPR=%REPR_STR% -GFILE=%FILE_PTN% -GFOLDER=%FOLD_PTN% -GCODE=99 -GOPT=%OPT%
goto OVER

:INVALID_ARG
echo.
echo sakura-gr:
echo   引数が不正です。
echo.
goto EXAMPLE

:DQ_REQUIRED
echo.
echo sakura-gr:
echo   オプション以外の各引数は「"」引用符でくくってください。
echo.
goto EXAMPLE

:EXAMPLE
echo   (example)
echo     sakura-gr SU "●" "★" "*.txt" ".\child"
echo     sakura-gr N "●" "" "*.txt" ".\space folder"
echo.
echo   (you)
echo     sakura-gr %1 %2 %3 %4 %5
echo.

:OVER
endlocal
exit /b
