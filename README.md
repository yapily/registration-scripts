# registration-scripts
Helper scripts to help direct customers create Open Banking certificates

__NOTE: These instructions are not a replacement for the Open Banking Documentation which should be read [here](https://openbanking.atlassian.net/wiki/spaces/DZ/pages/1150124033/Directory+2.0+Technical+Overview+v1.5?preview=/1150124033/1731199716/OpenSSL%20eIDAS%20PSD2%20Certificate%20Signing%20Request%20Profiles%20Issue%202_3.pdf).__

## Prerequisites 

These instructions assume that you have the appropriate access to the **Open Banking Directory** for the **Production** environment already.
See [Access to Open Banking Directory](https://docs.yapily.com/guides/applications/institutions/registration/direct/uk-prereqs/#access-to-open-banking-directory) for more information.

Install/Upgrade OpenSSL to the latest version using [Homebrew](https://brew.sh/):

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

- Update the `countryName` (line 31) with the [2-letter country code](https://www.nationsonline.org/oneworld/country_code_list.htm) for your country if it differs from `GB`
- Update the `organizationName` (line 32) to the **Business Information Name** from the Open Banking Directory
- Update the `organizationIdentifier` (line 48) to the identifier issued by your National Competent Authority (NCA) e.g.
    - For the Financial Conduct Authority (FCA), the format will be `PSDGB-FCA-XXXXXX` where XXXXXX should be replaced with the 6-digit **Competency Authority Claims Registration Id** from the Open Banking Directory
    - For the Polish Financial Supervision Authority (PFSA), the format will be `PSDPL-PFSA-XXXXXXXXXX`
- Update the `commonName` (line 49) to the your **Business Information Organisation Id** from the Open Banking Directory
- Uncomment one of the `qcStatements` lines in each file based on roles you have under the **Competency Authority Claims Authorisations** from the Open Banking Directory: 
    - If you're an AISP only, uncomment out the line below `# PSP_AI` (line 164 in obseal.cnf **and** line 175 in obwac.cnf)
    - If you're an PISP only, uncomment out the line below `# PSP_PI` (line 162 in obseal.cnf **and**  line 173 in obwac.cnf)
    - If you have both AISP and PISP, uncomment out the line below the comment `# PSP_PI,PSP_AI` (line 174 in obseal.cnf **and**  line 185 in obwac.cnf)

## Running the file

To run create the keys and certificate signing requests (CSRs) for the `OB Seal` and `OB WAC`, run execute the following:

```
./generate_keys.sh [ss-client-id]
```

- Make sure you apply the software statement `client-id` as the only parameter
- You will be prompted initially to create a passphrase for both the `OB Seal` and `OB WAC` keys but new keys will be generated from them without a 
passphrase for your use.
- A successful execution of the script will generate 6 files## Upload the CSRs to Open Banking Directory

## Upload the CSR files

Next, upload the .csr files for the `OB Seal` and `OB WAC`:
- Select `OB WAC` and upload the `obwac` `.csr` file
- Select `OB Seal` and upload the `obseal` `.csr` file

If you have done everything successfully, you should see a green notification in the UI confirming the upload was successful, otherwise, check that
you have completed all the steps to set your config and you have selected roles your eligible for in the dashboard.

Now return to [Create a Software Statement](https://docs.yapily.com/guides/applications/institutions/registration/direct/uk-prereqs#create-a-software-statement) for information on how to complete the final steps required in the Open Banking Directory.
