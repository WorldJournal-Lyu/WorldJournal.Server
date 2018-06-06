<#

WorldJournal.Server.psm1

    2018-05-07 Initial creation
    2018-05-08 Implement Xml
    2018-05-09 Implement Dynamic parameter
    2018-05-17 Add 'Name' property
    2018-05-18 Get-WJDrive:
                 Rename function to 'Get-WJPath'
                 Remove 'Letter' and 'Department' parameter
                 Add 'Name' parameter
               Get-WJFTP:
                 Rename 'Company' paramenter to 'Name'
                 Remove 'Path', 'User', and 'Pass' parameter
    2018-05-23 Move 'WorldJournal.Server.xml' and 'CreateServerXml.ps1' to _DoNotRepository folder
    
#>

$xmlPath = (Split-Path (Split-Path ($MyInvocation.MyCommand.Path) -Parent) -Parent)+"\_DoNotRepository\"+(($MyInvocation.MyCommand.Name) -replace '.psm1', '.xml')

if (Test-Path $xmlPath){
    # do nothing
}else{
    # create new xml file
    . ($xmlPath -replace 'WorldJournal.Server.xml', 'CreateServerXml.ps1') -Overwrite true
}

[xml]$xml = Get-Content $xmlPath -Encoding UTF8

function Get-WJPath() {

    [CmdletBinding()]
    Param ()
    DynamicParam {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        $attributes1 = New-Object System.Management.Automation.ParameterAttribute
        $attributes1.Mandatory = $false
        $attributes1.ParameterSetName = '__AllParameterSets'
        $attributeCollection1 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection1.Add($attributes1)
        $values1 = $xml.Root.Local.NetworkPath.Name | Select-Object -Unique
        $validateSet1 = New-Object System.Management.Automation.ValidateSetAttribute($values1)    
        $attributeCollection1.Add($validateSet1)
        $dynamicParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Name", [string], $attributeCollection1
        )

        $attributes2 = New-Object System.Management.Automation.ParameterAttribute
        $attributes2.Mandatory = $false
        $attributes2.ParameterSetName = '__AllParameterSets'
        $attributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection2.Add($attributes2)
        $values2 = $xml.Root.Local.NetworkPath.Path | Select-Object -Unique
        $validateSet2 = New-Object System.Management.Automation.ValidateSetAttribute($values2)    
        $attributeCollection2.Add($validateSet2)
        $dynamicParam2 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Path", [string], $attributeCollection2
        )

        $paramDictionary.Add("Name", $dynamicParam1)
        $paramDictionary.Add("Path", $dynamicParam2)

        return $paramDictionary

    }

    begin {}
    process {

        $Name = $PSBoundParameters.Name
        $Path = $PSBoundParameters.Path

        $whereArray = @()
        if ($Name -ne $null) { $whereArray += '$_.Name -eq $Name' }
        if ($Path -ne $null) { $whereArray += '$_.Path -eq $Path' }
        $whereString = $whereArray -Join " -and "  
        $whereBlock = [scriptblock]::Create( $whereString )

        if ($PSBoundParameters.Count -ne 0) {
            $xml.Root.Local.NetworkPath | Where-Object -FilterScript $whereBlock | Select-Object Name, Path
        }
        else {
            $xml.Root.Local.NetworkPath |  Select-Object Name, Path
        }

    }
    end {}
}



function Get-WJFTP() {
    [CmdletBinding()]
    Param ()
    DynamicParam {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false
        $attributes.ParameterSetName = '__AllParameterSets'
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        $values = $xml.Root.Remote.FileTransferProtocol.Name | Select-Object -Unique
        $validateSet = New-Object System.Management.Automation.ValidateSetAttribute($values)    
        $attributeCollection.Add($validateSet)
        $dynamicParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Name", [string], $attributeCollection
        )

        $paramDictionary.Add("Name", $dynamicParam)

        return $paramDictionary

    }

    begin {}
    process {

        $Name = $PSBoundParameters.Name
    
        $whereArray = @()
        if ($Name -ne $null) { $whereArray += '$_.Name -eq $Name' }
        $whereString = $whereArray -Join " -and "  
        $whereBlock = [scriptblock]::Create( $whereString )

        if ($PSBoundParameters.Count -ne 0) {
            $xml.Root.Remote.FileTransferProtocol | Where-Object -FilterScript $whereBlock | Select-Object Name, Path, User, Pass
        }
        else {
            $xml.Root.Remote.FileTransferProtocol | Select-Object Name, Path, User, Pass
        }

    }
    end {}
}



function Get-WJServerXmlPath() {
    $xmlPath
}


<# original version of Get-WJDrive, uses three dynamic parameters

function Get-WJDrive() {

    [CmdletBinding()]
    Param ()
    DynamicParam {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $false
        $attributes.ParameterSetName = '__AllParameterSets'
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        $values = $xml.Root.Local.NetworkPath.Letter | Select-Object -Unique
        $validateSet = New-Object System.Management.Automation.ValidateSetAttribute($values)    
        $attributeCollection.Add($validateSet)
        $dynamicParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Letter", [string], $attributeCollection
        )

        $attributes1 = New-Object System.Management.Automation.ParameterAttribute
        $attributes1.Mandatory = $false
        $attributes1.ParameterSetName = '__AllParameterSets'
        $attributeCollection1 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection1.Add($attributes1)
        $values1 = $xml.Root.Local.NetworkPath.Department | Select-Object -Unique
        $validateSet1 = New-Object System.Management.Automation.ValidateSetAttribute($values1)    
        $attributeCollection1.Add($validateSet1)
        $dynamicParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Department", [string], $attributeCollection1
        )

        $attributes2 = New-Object System.Management.Automation.ParameterAttribute
        $attributes2.Mandatory = $false
        $attributes2.ParameterSetName = '__AllParameterSets'
        $attributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection2.Add($attributes2)
        $values2 = $xml.Root.Local.NetworkPath.Path | Select-Object -Unique
        $validateSet2 = New-Object System.Management.Automation.ValidateSetAttribute($values2)    
        $attributeCollection2.Add($validateSet2)
        $dynamicParam2 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Path", [string], $attributeCollection2
        )

        $attributes3 = New-Object System.Management.Automation.ParameterAttribute
        $attributes3.Mandatory = $false
        $attributes3.ParameterSetName = '__AllParameterSets'
        $attributeCollection3 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection3.Add($attributes3)
        $values3 = $xml.Root.Local.NetworkPath.Name | Select-Object -Unique
        $validateSet3 = New-Object System.Management.Automation.ValidateSetAttribute($values3)    
        $attributeCollection3.Add($validateSet3)
        $dynamicParam3 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter(
            "Name", [string], $attributeCollection3
        )

        $paramDictionary.Add("Letter", $dynamicParam)
        $paramDictionary.Add("Department", $dynamicParam1)
        $paramDictionary.Add("Path", $dynamicParam2)
        $paramDictionary.Add("Name", $dynamicParam3)

        return $paramDictionary

    }

    begin {}
    process {

        $Letter = $PSBoundParameters.Letter
        $Department = $PSBoundParameters.Department
        $Path = $PSBoundParameters.Path
        $Name = $PSBoundParameters.Name

        $whereArray = @()
        if ($Letter -ne $null) { $whereArray += '$_.Letter -eq $Letter' }
        if ($Department -ne $null) { $whereArray += '$_.Department -eq $Department' }
        if ($Path -ne $null) { $whereArray += '$_.Path -eq $Path' }
        if ($Name -ne $null) { $whereArray += '$_.Name -eq $Name' }
        $whereString = $whereArray -Join " -and "  
        $whereBlock = [scriptblock]::Create( $whereString )

        if ($PSBoundParameters.Count -ne 0) {
            $xml.Root.Local.NetworkPath | Where-Object -FilterScript $whereBlock | Select-Object Letter, Department, Path, Name
        }
        else {
            $xml.Root.Local.NetworkPath |  Select-Object Letter, Department, Path, Name
        }

    }
    end {}
}


#>