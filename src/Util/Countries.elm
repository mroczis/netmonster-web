module Util.Countries exposing
    ( Country
    , fromCode, search
    , all
    , allWithNone
    , nameWithFlag
    , none
    , fromCodeOrNone
    , unknown
    )

{-| A searchable [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) based list of country names, codes and emoji flags.

The library is intended to be used qualified (i.e. `Countries.search`, `Countries.all`).

    > import Countries
    > Countries.fromCode "AU"
    Just { name = "Australia", code = "AU", flag = "🇦🇺" }
        : Maybe.Maybe Countries.Country

See the `examples` folder for a basic country picker example.

Note: [Country names do change](https://github.com/supermario/elm-countries/commit/0c0475df983c35f936a19c14383385ca4bc96cb5)! It's best to use the code as a key if you are using and storing country details outside of this library.


# Types

@docs Country


# Common helpers

@docs fromCode, search


# Data set

@docs all

-}


{-| The Country record type.

  - name: The [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) Country name
  - code: [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) two-letter Country code
  - flag: The Country's unicode emoji flag, see [Regional Indicator Symbol](https://en.wikipedia.org/wiki/Regional_Indicator_Symbol)

This type is intentionally not opaque, as accessing the countries reference data as easily as possible is the primary goal.

THIS IS just copy of original file with some changes

  - shorter names of countries
  - removed countries that we do not support

-}
type alias Country =
    { name : String, code : Maybe String, flag : String }


{-| Find a country by its [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) two-letter country code.
-}
fromCode : String -> Maybe Country
fromCode code =
    if String.length code /= 2 then
        Nothing

    else
        all
            |> List.filter
                (\country ->
                    country.code == Just code
                )
            |> List.head


{-| Search all Countries by case-insensitive string matching on name and code
-}
search : String -> List Country
search searchString =
    all
        |> List.filter
            (\country ->
                String.contains
                    (String.toLower searchString)
                    (String.toLower <| country.name ++ (country.code |> Maybe.withDefault ""))
            )


{-| The full list of all 249 current [ISO 3166-1](https://en.wikipedia.org/wiki/ISO_3166-1) Country records.
-}
all : List Country
all =
    [ ( "Andorra", "AD", "🇦🇩" )
    , ( "United Arab Emirates", "AE", "🇦🇪" )
    , ( "Afghanistan", "AF", "🇦🇫" )
    , ( "Antigua and Barbuda", "AG", "🇦🇬" )
    , ( "Anguilla", "AI", "🇦🇮" )
    , ( "Albania", "AL", "🇦🇱" )
    , ( "Armenia", "AM", "🇦🇲" )
    , ( "Angola", "AO", "🇦🇴" )
    , ( "Antarctica", "AQ", "🇦🇶" )
    , ( "Argentina", "AR", "🇦🇷" )
    , ( "American Samoa", "AS", "🇦🇸" )
    , ( "Austria", "AT", "🇦🇹" )
    , ( "Australia", "AU", "🇦🇺" )
    , ( "Aruba", "AW", "🇦🇼" )
    , ( "Åland Islands", "AX", "🇦🇽" )
    , ( "Azerbaijan", "AZ", "🇦🇿" )
    , ( "Bosnia and Herzegovina", "BA", "🇧🇦" )
    , ( "Barbados", "BB", "🇧🇧" )
    , ( "Bangladesh", "BD", "🇧🇩" )
    , ( "Belgium", "BE", "🇧🇪" )
    , ( "Burkina Faso", "BF", "🇧🇫" )
    , ( "Bulgaria", "BG", "🇧🇬" )
    , ( "Bahrain", "BH", "🇧🇭" )
    , ( "Burundi", "BI", "🇧🇮" )
    , ( "Benin", "BJ", "🇧🇯" )
    , ( "Saint Barthélemy", "BL", "🇧🇱" )
    , ( "Bermuda", "BM", "🇧🇲" )
    , ( "Brunei Darussalam", "BN", "🇧🇳" )
    , ( "Bolivia", "BO", "🇧🇴" )
    , ( "Bonaire", "BQ", "🇧🇶" )
    , ( "Brazil", "BR", "🇧🇷" )
    , ( "Bahamas", "BS", "🇧🇸" )
    , ( "Bhutan", "BT", "🇧🇹" )
    , ( "Bouvet Island", "BV", "🇧🇻" )
    , ( "Botswana", "BW", "🇧🇼" )
    , ( "Belarus", "BY", "🇧🇾" )
    , ( "Belize", "BZ", "🇧🇿" )
    , ( "Canada", "CA", "🇨🇦" )
    , ( "Cocos Islands", "CC", "🇨🇨" )
    , ( "Congo", "CD", "🇨🇩" )
    , ( "Central African Republic", "CF", "🇨🇫" )
    , ( "Congo", "CG", "🇨🇬" )
    , ( "Switzerland", "CH", "🇨🇭" )
    , ( "Côte d'Ivoire", "CI", "🇨🇮" )
    , ( "Cook Islands", "CK", "🇨🇰" )
    , ( "Chile", "CL", "🇨🇱" )
    , ( "Cameroon", "CM", "🇨🇲" )
    , ( "China", "CN", "🇨🇳" )
    , ( "Colombia", "CO", "🇨🇴" )
    , ( "Costa Rica", "CR", "🇨🇷" )
    , ( "Cuba", "CU", "🇨🇺" )
    , ( "Cabo Verde", "CV", "🇨🇻" )
    , ( "Curaçao", "CW", "🇨🇼" )
    , ( "Christmas Island", "CX", "🇨🇽" )
    , ( "Cyprus", "CY", "🇨🇾" )
    , ( "Czechia", "CZ", "🇨🇿" )
    , ( "Germany", "DE", "🇩🇪" )
    , ( "Djibouti", "DJ", "🇩🇯" )
    , ( "Denmark", "DK", "🇩🇰" )
    , ( "Dominica", "DM", "🇩🇲" )
    , ( "Dominican Republic", "DO", "🇩🇴" )
    , ( "Algeria", "DZ", "🇩🇿" )
    , ( "Ecuador", "EC", "🇪🇨" )
    , ( "Estonia", "EE", "🇪🇪" )
    , ( "Egypt", "EG", "🇪🇬" )
    , ( "Western Sahara", "EH", "🇪🇭" )
    , ( "Eritrea", "ER", "🇪🇷" )
    , ( "Spain", "ES", "🇪🇸" )
    , ( "Ethiopia", "ET", "🇪🇹" )
    , ( "Finland", "FI", "🇫🇮" )
    , ( "Fiji", "FJ", "🇫🇯" )
    , ( "Falkland Islands", "FK", "🇫🇰" )
    , ( "Micronesia", "FM", "🇫🇲" )
    , ( "Faroe Islands", "FO", "🇫🇴" )
    , ( "France", "FR", "🇫🇷" )
    , ( "Gabon", "GA", "🇬🇦" )
    , ( "United Kingdom", "GB", "🇬🇧" )
    , ( "Grenada", "GD", "🇬🇩" )
    , ( "Georgia", "GE", "🇬🇪" )
    , ( "French Guiana", "GF", "🇬🇫" )
    , ( "Guernsey", "GG", "🇬🇬" )
    , ( "Ghana", "GH", "🇬🇭" )
    , ( "Gibraltar", "GI", "🇬🇮" )
    , ( "Greenland", "GL", "🇬🇱" )
    , ( "Gambia", "GM", "🇬🇲" )
    , ( "Guinea", "GN", "🇬🇳" )
    , ( "Guadeloupe", "GP", "🇬🇵" )
    , ( "Equatorial Guinea", "GQ", "🇬🇶" )
    , ( "Greece", "GR", "🇬🇷" )
    , ( "Guatemala", "GT", "🇬🇹" )
    , ( "Guam", "GU", "🇬🇺" )
    , ( "Guinea-Bissau", "GW", "🇬🇼" )
    , ( "Guyana", "GY", "🇬🇾" )
    , ( "Hong Kong", "HK", "🇭🇰" )
    , ( "Honduras", "HN", "🇭🇳" )
    , ( "Croatia", "HR", "🇭🇷" )
    , ( "Haiti", "HT", "🇭🇹" )
    , ( "Hungary", "HU", "🇭🇺" )
    , ( "Indonesia", "ID", "🇮🇩" )
    , ( "Ireland", "IE", "🇮🇪" )
    , ( "Israel", "IL", "🇮🇱" )
    , ( "Isle of Man", "IM", "🇮🇲" )
    , ( "India", "IN", "🇮🇳" )
    , ( "Iraq", "IQ", "🇮🇶" )
    , ( "Iran", "IR", "🇮🇷" )
    , ( "Iceland", "IS", "🇮🇸" )
    , ( "Italy", "IT", "🇮🇹" )
    , ( "Jersey", "JE", "🇯🇪" )
    , ( "Jamaica", "JM", "🇯🇲" )
    , ( "Jordan", "JO", "🇯🇴" )
    , ( "Japan", "JP", "🇯🇵" )
    , ( "Kenya", "KE", "🇰🇪" )
    , ( "Kyrgyzstan", "KG", "🇰🇬" )
    , ( "Cambodia", "KH", "🇰🇭" )
    , ( "Kiribati", "KI", "🇰🇮" )
    , ( "Comoros", "KM", "🇰🇲" )
    , ( "Saint Kitts and Nevis", "KN", "🇰🇳" )
    , ( "North Korea", "KP", "🇰🇵" )
    , ( "South Korea", "KR", "🇰🇷" )
    , ( "Kuwait", "KW", "🇰🇼" )
    , ( "Cayman Islands", "KY", "🇰🇾" )
    , ( "Kazakhstan", "KZ", "🇰🇿" )
    , ( "Laos", "LA", "🇱🇦" )
    , ( "Lebanon", "LB", "🇱🇧" )
    , ( "Saint Lucia", "LC", "🇱🇨" )
    , ( "Liechtenstein", "LI", "🇱🇮" )
    , ( "Sri Lanka", "LK", "🇱🇰" )
    , ( "Liberia", "LR", "🇱🇷" )
    , ( "Lesotho", "LS", "🇱🇸" )
    , ( "Lithuania", "LT", "🇱🇹" )
    , ( "Luxembourg", "LU", "🇱🇺" )
    , ( "Latvia", "LV", "🇱🇻" )
    , ( "Libya", "LY", "🇱🇾" )
    , ( "Morocco", "MA", "🇲🇦" )
    , ( "Monaco", "MC", "🇲🇨" )
    , ( "Moldova", "MD", "🇲🇩" )
    , ( "Montenegro", "ME", "🇲🇪" )
    , ( "Saint Martin", "MF", "🇲🇫" )
    , ( "Madagascar", "MG", "🇲🇬" )
    , ( "Marshall Islands", "MH", "🇲🇭" )
    , ( "North Macedonia", "MK", "🇲🇰" )
    , ( "Mali", "ML", "🇲🇱" )
    , ( "Myanmar", "MM", "🇲🇲" )
    , ( "Mongolia", "MN", "🇲🇳" )
    , ( "Macao", "MO", "🇲🇴" )
    , ( "Martinique", "MQ", "🇲🇶" )
    , ( "Mauritania", "MR", "🇲🇷" )
    , ( "Montserrat", "MS", "🇲🇸" )
    , ( "Malta", "MT", "🇲🇹" )
    , ( "Mauritius", "MU", "🇲🇺" )
    , ( "Maldives", "MV", "🇲🇻" )
    , ( "Malawi", "MW", "🇲🇼" )
    , ( "Mexico", "MX", "🇲🇽" )
    , ( "Malaysia", "MY", "🇲🇾" )
    , ( "Mozambique", "MZ", "🇲🇿" )
    , ( "Namibia", "NA", "🇳🇦" )
    , ( "New Caledonia", "NC", "🇳🇨" )
    , ( "Niger", "NE", "🇳🇪" )
    , ( "Norfolk Island", "NF", "🇳🇫" )
    , ( "Nigeria", "NG", "🇳🇬" )
    , ( "Nicaragua", "NI", "🇳🇮" )
    , ( "Netherlands", "NL", "🇳🇱" )
    , ( "Norway", "NO", "🇳🇴" )
    , ( "Nepal", "NP", "🇳🇵" )
    , ( "Nauru", "NR", "🇳🇷" )
    , ( "Niue", "NU", "🇳🇺" )
    , ( "New Zealand", "NZ", "🇳🇿" )
    , ( "Oman", "OM", "🇴🇲" )
    , ( "Panama", "PA", "🇵🇦" )
    , ( "Peru", "PE", "🇵🇪" )
    , ( "French Polynesia", "PF", "🇵🇫" )
    , ( "Papua New Guinea", "PG", "🇵🇬" )
    , ( "Philippines", "PH", "🇵🇭" )
    , ( "Pakistan", "PK", "🇵🇰" )
    , ( "Poland", "PL", "🇵🇱" )
    , ( "Saint Pierre and Miquelon", "PM", "🇵🇲" )
    , ( "Pitcairn", "PN", "🇵🇳" )
    , ( "Puerto Rico", "PR", "🇵🇷" )
    , ( "Palestine, State of", "PS", "🇵🇸" )
    , ( "Portugal", "PT", "🇵🇹" )
    , ( "Palau", "PW", "🇵🇼" )
    , ( "Paraguay", "PY", "🇵🇾" )
    , ( "Qatar", "QA", "🇶🇦" )
    , ( "Réunion", "RE", "🇷🇪" )
    , ( "Romania", "RO", "🇷🇴" )
    , ( "Serbia", "RS", "🇷🇸" )
    , ( "Russia", "RU", "🇷🇺" )
    , ( "Rwanda", "RW", "🇷🇼" )
    , ( "Saudi Arabia", "SA", "🇸🇦" )
    , ( "Solomon Islands", "SB", "🇸🇧" )
    , ( "Seychelles", "SC", "🇸🇨" )
    , ( "Sudan", "SD", "🇸🇩" )
    , ( "Sweden", "SE", "🇸🇪" )
    , ( "Singapore", "SG", "🇸🇬" )
    , ( "Saint Helena", "SH", "🇸🇭" )
    , ( "Slovenia", "SI", "🇸🇮" )
    , ( "Slovakia", "SK", "🇸🇰" )
    , ( "Sierra Leone", "SL", "🇸🇱" )
    , ( "San Marino", "SM", "🇸🇲" )
    , ( "Senegal", "SN", "🇸🇳" )
    , ( "Somalia", "SO", "🇸🇴" )
    , ( "Suriname", "SR", "🇸🇷" )
    , ( "South Sudan", "SS", "🇸🇸" )
    , ( "Sao Tome and Principe", "ST", "🇸🇹" )
    , ( "El Salvador", "SV", "🇸🇻" )
    , ( "Sint Maarten", "SX", "🇸🇽" )
    , ( "Syria", "SY", "🇸🇾" )
    , ( "Eswatini", "SZ", "🇸🇿" )
    , ( "Turks and Caicos Islands", "TC", "🇹🇨" )
    , ( "Chad", "TD", "🇹🇩" )
    , ( "Togo", "TG", "🇹🇬" )
    , ( "Thailand", "TH", "🇹🇭" )
    , ( "Tajikistan", "TJ", "🇹🇯" )
    , ( "Tokelau", "TK", "🇹🇰" )
    , ( "Timor-Leste", "TL", "🇹🇱" )
    , ( "Turkmenistan", "TM", "🇹🇲" )
    , ( "Tunisia", "TN", "🇹🇳" )
    , ( "Tonga", "TO", "🇹🇴" )
    , ( "Turkey", "TR", "🇹🇷" )
    , ( "Trinidad and Tobago", "TT", "🇹🇹" )
    , ( "Tuvalu", "TV", "🇹🇻" )
    , ( "Taiwan", "TW", "🇹🇼" )
    , ( "Tanzania", "TZ", "🇹🇿" )
    , ( "Ukraine", "UA", "🇺🇦" )
    , ( "Uganda", "UG", "🇺🇬" )
    , ( "USA", "US", "🇺🇸" )
    , ( "Uruguay", "UY", "🇺🇾" )
    , ( "Uzbekistan", "UZ", "🇺🇿" )
    , ( "Holy See", "VA", "🇻🇦" )
    , ( "Saint Vincent and the Grenadines", "VC", "🇻🇨" )
    , ( "Venezuela", "VE", "🇻🇪" )
    , ( "Virgin Islands (UK)", "VG", "🇻🇬" )
    , ( "Virgin Islands (US)", "VI", "🇻🇮" )
    , ( "Vietnam", "VN", "🇻🇳" )
    , ( "Vanuatu", "VU", "🇻🇺" )
    , ( "Wallis and Futuna", "WF", "🇼🇫" )
    , ( "Samoa", "WS", "🇼🇸" )
    , ( "Kosovo", "XK", "🇽🇰" )
    , ( "Yemen", "YE", "🇾🇪" )
    , ( "Mayotte", "YT", "🇾🇹" )
    , ( "South Africa", "ZA", "🇿🇦" )
    , ( "Zambia", "ZM", "🇿🇲" )
    , ( "Zimbabwe", "ZW", "🇿🇼" )
    ]
        |> List.map (\( name, code, flag ) -> Country name (Just code) flag)



--
-- Added functions
--

none : Country
none = Country "All" Nothing "🏳️‍🌈"

unknown : Country
unknown = Country "Unknown" Nothing "🏳️‍"

fromCodeOrNone : Maybe String -> Country
fromCodeOrNone = Maybe.withDefault "" >> fromCode >> Maybe.withDefault none

nameWithFlag : Country -> String
nameWithFlag country =
    country.flag ++ " " ++ country.name


allWithNone : List Country
allWithNone =
    let
        sorted =
            List.sortBy .name all
    in
    none :: sorted
