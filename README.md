# registration-scripts
Helper scripts to help direct customers create Open Banking certificates

The following repository is not production code but will help you to generate certificates in line with the Open Banking Directory. 

__NOTE: These instructions are not a replacement for the Open Banking Documentation which should be read [here](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1150124033/Directory+2.0+Technical+Overview+v1.5?preview=/1150124033/1731199716/OpenSSL%20eIDAS%20PSD2%20Certificate%20Signing%20Request%20Profiles%20Issue%202_3.pdf).__

## Prerequisites 

Install/Upgrade OpenSSL to the latest version:

<details>
<summary>Mac</summary>
    <code>
    brew install libressl
    </code>
    <br>OR<br>
    <code>
    brew upgrade libressl
    </code>
</details>

## Updating the Config

Before running the script open up `config-files/obseal.cnf` and `config-files/obwac.cnf` and make the following changes to both files:

- Update the `countryName` (line 31) with the [2-letter country code](https://www.nationsonline.org/oneworld/country_code_list.htm) for your country
- Update the `organizationName` (line 32) to the name of your company
- Update the `organizationIdentifier` (line 48) to the identifier issued by your National Competent Authority (NCA) e.g.
    - For the Financial Conduct Authority (FCA), the format will be `PSDGB-FCA-123456`
    - For the Polish Financial Supervision Authority (PFSA), the format will be `PSDPL-PFSA-1234567890`
- Update the `commonName` (line 49) to the your **Organisation Id** from the Open Banking Directory
- Uncomment one of the `qcStatements` lines in each file: 
    - For AIS only, uncomment out the line below `# PSP_AI` (line 164 in obseal.cnf **and** line 175 in obwac.cnf)
    - For PIS only, uncomment out the line below `# PSP_PI` (line 162 in obseal.cnf **and**  line 173 in obwac.cnf)
    - For AIS and PIS, uncomment out the line below the comment `# PSP_PI,PSP_AI` (line 174 in obseal.cnf **and**  line 185 in obwac.cnf)

## Running the file

To run create the keys and certificate signing requests (CSRs) for the `OB Seal` and `OB WAC`, run execute the following:

```
./generate_keys.sh [SS_CLIENT_ID]
```

- Make sure you apply the software statement `client-id` as the only parameter
- You will be prompted initially to create a passphrase for both the `OB Seal` and `OB WAC` keys but new keys will be generated from them without a passphrase for your use.
- A successful execution of the script will generate 6 files

## Upload the CSRs to Open Banking Directory

Next, upload the .csr files for the `OB Seal` and `OB WAC`:
- Select `OB WAC` and upload the `obwac` `.csr` file
- Select `OB Seal` and upload the `obseal` `.csr` file

You will then need to download the `.pem` files for each certificate in the menu options for each certificate type. You can do this by clicking on the three dots for each cert
in the certificates table from the appropriate software statement view within the Open Banking Directory and selecting "Get PEM". 

You can then use the rename the files to make them more identifiable using the following convention:

```
[certType].[companyName].SSID.[softwareStatementClientId].KID.[certKID].[fileExtension]
```

The end result should be 4 files in the format:

```
obwac.[companyName].SSID.[softwareStatementClientId].KID.[obwacCertKID].key
obwac.[companyName].SSID.[softwareStatementClientId].KID.[obwacCertKID].pem
obseal.[companyName].SSID.[softwareStatementClientId].KID.[obsealCertKID].key
obseal.[companyName].SSID.[softwareStatementClientId].KID.[obsealCertKID].pem
```

Assuming you have not changed the file names from when you created the CSRs, you should be able to use the `rename_files.sh` script to do this for you:

```
rename_files.sh \
   -company-name [your-company] \
   -ssid         [software-statement-id] \
   -obseal-pem   [obseal-pem-file] \
   -obseal-key   [obseal-key-file] \
   -obwac-pem    [obwac-pem-file] \
   -obwac-key    [obwac-key-file]
```

## Upload the QWAC and QSEAL key and pem files to Yapily

1. Go to the [Yapily Dashboard](https://dashboard.yapily.com/) and login
2. Go to the [Certificates](https://dashboard.yapily.com/#!certificates) page 
3. Click the "Add Certificate" button
4. Upload your OB Seal pem file for the certificate
5. Upload your OB Seal key file for the certificate 
6. Name the certificate after ether of the file names without the extension 
7. Save 
8. Repeat steps 4-7 for the OB WAC files