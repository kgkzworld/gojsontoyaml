#region Build Notes
<#
    o 21.3.301: • [Michael Arroyo] Posted
#>
#endregion Build Notes

#region Main
    #region Create Hash
        $GoJSONtoYAMLInfo = @{}
    #endregion Create Hash

    #region Script File and Path Values
        $GoJSONtoYAMLInfo['PSScriptRoot'] = $PSScriptRoot

        If
        (
            $GoJSONtoYAMLInfo['PSScriptRoot'] -eq ''
        )
        {
            If
            (
                $Host.Name -match 'ISE'
            )
            {
                $GoJSONtoYAMLInfo['PSScriptRoot'] = Split-Path -Path $psISE.CurrentFile.FullPath -Parent
            }
        }
    #endregion Script File and Path Values

    #region Script Settings Values
        $GoJSONtoYAMLInfo['ScriptSettings'] = @{}
        $GoJSONtoYAMLInfo['ScriptSettings']['TimeStamp'] = $('D{0}' -f $(Get-Date -Format dd.MM.yyyy-hh.mm.ss.ff.tt)) -replace '-','_T'
        $GoJSONtoYAMLInfo['ScriptSettings']['CurrentUser'] = $($env:USERNAME)
        $GoJSONtoYAMLInfo['ScriptSettings']['CurrentComputer'] = $env:COMPUTERNAME.ToUpper()
        $GoJSONtoYAMLInfo['ScriptSettings']['WorkingPath'] = $GoJSONtoYAMLInfo.PSScriptRoot
        $GoJSONtoYAMLInfo['ScriptSettings']['LoadedFunctionsPrv'] = @()
        $GoJSONtoYAMLInfo['ScriptSettings']['LoadedFunctionsPub'] = @()
        $GoJSONtoYAMLInfo['ScriptSettings']['LoadedVariablesPub'] = @()
        $GoJSONtoYAMLInfo['ScriptSettings']['LoadedAliasesPub'] = @()
        $GoJSONtoYAMLInfo['ScriptSettings']['Log'] = @()
    #endregion Script Settings Values

    #region Query Private Functions
        $GoJSONtoYAMLPrivate = Get-ChildItem -Path $(Join-Path -Path $($GoJSONtoYAMLInfo.ScriptSettings.Workingpath) -ChildPath 'Private') -Filter '*.ps1' -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -Property BaseName,FullName
    #endregion Query Core Path

    #region Query Public Functions
        $GoJSONtoYAMLPublic = Get-ChildItem -Path $(Join-Path -Path $($GoJSONtoYAMLInfo.ScriptSettings.Workingpath) -ChildPath 'Public') -Filter '*.ps1' -Force -Recurse -ErrorAction SilentlyContinue | Select-Object -Property BaseName,FullName
    #endregion Query Core Path

    #region Dynamically Build Functions from .PS1 files
        If
        (
            $GoJSONtoYAMLPrivate
        )
        {
            $GoJSONtoYAMLPrivate | ForEach-Object `
            -Process `
            {
                Try
                {
                    . $($_ | Select-Object -ExpandProperty FullName)
                    $GoJSONtoYAMLInfo['ScriptSettings']['LoadedFunctionsPrv'] += $($_ | Select-Object -ExpandProperty BaseName)
                }
                Catch
                {
                    #Nothing
                }
            }
        }

        If
        (
            $GoJSONtoYAMLPublic
        )
        {
            $GoJSONtoYAMLPublic | ForEach-Object `
            -Process `
            {
                Try
                {
                    . $($_ | Select-Object -ExpandProperty FullName)
                    $GoJSONtoYAMLInfo['ScriptSettings']['LoadedFunctionsPub'] += $($_ | Select-Object -ExpandProperty BaseName)
                }
                Catch
                {
                    #Nothing
                }
            }
        }
    #endregion Dynamically Build Functions from .PS1 files

    #region Dynamically Build Export Variable list
        $GoJSONtoYAMLInfo['ScriptSettings']['LoadedVariablesPub'] += 'GoJSONtoYAMLInfo'
    #endregion Dynamically Build Export Variable list

    #region Export Module Members
        Export-ModuleMember `
        -Function $($GoJSONtoYAMLInfo['ScriptSettings']['LoadedFunctionsPub']) `
        -Variable $($GoJSONtoYAMLInfo['ScriptSettings']['LoadedVariablesPub']) `
        #-Alias $($BluGenieInfo['ScriptSettings']['LoadedAliases'] | Select-Object -ExpandProperty Name)
    #endregion Export Module Members
#endregion Main