module FontData exposing (CharInfo, font, spriteSrc)

import Dict exposing (Dict)


type alias CharInfo =
    { x : Float
    , y : Float
    , w : Float
    }


font : Dict String CharInfo
font =
    Dict.fromList
        [ ( "e", CharInfo 0 0 3 )
        , ( "q", CharInfo 4 0 3 )
        , ( "Y", CharInfo 8 0 5 )
        , ( "l", CharInfo 14 0 1 )
        , ( "щ", CharInfo 16 0 6 )
        , ( "ш", CharInfo 23 0 5 )
        , ( "fi", CharInfo 29 0 4 )
        , ( "k", CharInfo 34 0 3 )
        , ( "X", CharInfo 38 0 5 )
        , ( "p", CharInfo 44 0 3 )
        , ( "d", CharInfo 48 0 3 )
        , ( "r", CharInfo 52 0 3 )
        , ( "f", CharInfo 56 0 4 )
        , ( "}", CharInfo 61 0 3 )
        , ( "j", CharInfo 65 0 3 )
        , ( "~", CharInfo 69 0 4 )
        , ( "g", CharInfo 74 0 3 )
        , ( "s", CharInfo 78 0 3 )
        , ( "z", CharInfo 82 0 3 )
        , ( "n", CharInfo 86 0 3 )
        , ( "w", CharInfo 90 0 5 )
        , ( "c", CharInfo 96 0 3 )
        , ( "b", CharInfo 100 0 3 )
        , ( "v", CharInfo 104 0 3 )
        , ( "m", CharInfo 108 0 5 )
        , ( "o", CharInfo 114 0 3 )
        , ( "{", CharInfo 118 0 3 )
        , ( "H", CharInfo 122 0 4 )
        , ( "t", CharInfo 0 11 3 )
        , ( "u", CharInfo 4 11 3 )
        , ( "a", CharInfo 8 11 3 )
        , ( "I", CharInfo 12 11 3 )
        , ( "|", CharInfo 16 11 1 )
        , ( "Ж", CharInfo 18 11 7 )
        , ( "К", CharInfo 26 11 4 )
        , ( "З", CharInfo 31 11 4 )
        , ( "9", CharInfo 36 11 4 )
        , ( "Ё", CharInfo 41 11 3 )
        , ( "Е", CharInfo 45 11 3 )
        , ( "Щ", CharInfo 49 11 6 )
        , ( "М", CharInfo 56 11 5 )
        , ( "Л", CharInfo 62 11 5 )
        , ( "Ш", CharInfo 68 11 5 )
        , ( "Д", CharInfo 74 11 5 )
        , ( "8", CharInfo 80 11 4 )
        , ( "jj", CharInfo 85 11 5 )
        , ( "(", CharInfo 91 11 3 )
        , ( "yj", CharInfo 95 11 5 )
        , ( "и", CharInfo 101 11 4 )
        , ( "П", CharInfo 106 11 4 )
        , ( "А", CharInfo 111 11 4 )
        , ( "Б", CharInfo 116 11 4 )
        , ( "й", CharInfo 121 11 4 )
        , ( ")", CharInfo 0 22 3 )
        , ( "ss", CharInfo 4 22 6 )
        , ( "О", CharInfo 11 22 4 )
        , ( "Г", CharInfo 16 22 3 )
        , ( "В", CharInfo 20 22 4 )
        , ( "Н", CharInfo 25 22 4 )
        , ( "'", CharInfo 30 22 1 )
        , ( "3", CharInfo 32 22 4 )
        , ( "*", CharInfo 37 22 5 )
        , ( ">", CharInfo 43 22 5 )
        , ( "з", CharInfo 49 22 3 )
        , ( "У", CharInfo 53 22 4 )
        , ( "к", CharInfo 58 22 3 )
        , ( "Ю", CharInfo 62 22 6 )
        , ( "Э", CharInfo 69 22 4 )
        , ( "Т", CharInfo 74 22 5 )
        , ( "ж", CharInfo 80 22 5 )
        , ( "=", CharInfo 86 22 4 )
        , ( "2", CharInfo 91 22 4 )
        , ( "&", CharInfo 96 22 6 )
        , ( "0", CharInfo 103 22 4 )
        , ( "$", CharInfo 108 22 4 )
        , ( "?", CharInfo 113 22 4 )
        , ( "+", CharInfo 118 22 5 )
        , ( "Р", CharInfo 124 22 4 )
        , ( "д", CharInfo 0 33 5 )
        , ( "Я", CharInfo 6 33 4 )
        , ( "л", CharInfo 11 33 3 )
        , ( "м", CharInfo 15 33 5 )
        , ( "е", CharInfo 21 33 3 )
        , ( "С", CharInfo 25 33 4 )
        , ( ",", CharInfo 30 33 2 )
        , ( "%", CharInfo 33 33 7 )
        , ( "1", CharInfo 41 33 4 )
        , ( "<", CharInfo 46 33 5 )
        , ( "5", CharInfo 52 33 4 )
        , ( "!", CharInfo 57 33 1 )
        , ( "Ь", CharInfo 59 33 4 )
        , ( "Й", CharInfo 64 33 4 )
        , ( "Х", CharInfo 69 33 5 )
        , ( "б", CharInfo 75 33 3 )
        , ( "а", CharInfo 79 33 3 )
        , ( "п", CharInfo 83 33 3 )
        , ( "И", CharInfo 87 33 4 )
        , ( "Ы", CharInfo 92 33 6 )
        , ( "4", CharInfo 99 33 4 )
        , ( "/", CharInfo 104 33 4 )
        , ( "×", CharInfo 109 33 5 )
        , ( ";", CharInfo 115 33 2 )
        , ( "-", CharInfo 118 33 4 )
        , ( "\"", CharInfo 123 33 3 )
        , ( "6", CharInfo 0 44 4 )
        , ( "н", CharInfo 5 44 3 )
        , ( "в", CharInfo 9 44 3 )
        , ( "Ц", CharInfo 13 44 5 )
        , ( "Ч", CharInfo 19 44 4 )
        , ( "г", CharInfo 24 44 3 )
        , ( "Ъ", CharInfo 28 44 5 )
        , ( "о", CharInfo 34 44 3 )
        , ( "7", CharInfo 38 44 4 )
        , ( "#", CharInfo 43 44 5 )
        , ( ":", CharInfo 49 44 1 )
        , ( ".", CharInfo 51 44 1 )
        , ( "ffi", CharInfo 53 44 6 )
        , ( "D", CharInfo 60 44 4 )
        , ( "P", CharInfo 65 44 4 )
        , ( "x", CharInfo 70 44 3 )
        , ( "K", CharInfo 74 44 4 )
        , ( "_", CharInfo 79 44 4 )
        , ( "р", CharInfo 84 44 3 )
        , ( "я", CharInfo 88 44 3 )
        , ( "с", CharInfo 92 44 3 )
        , ( "L", CharInfo 96 44 3 )
        , ( "y", CharInfo 100 44 3 )
        , ( "Q", CharInfo 104 44 4 )
        , ( "E", CharInfo 109 44 3 )
        , ( "S", CharInfo 113 44 4 )
        , ( "G", CharInfo 118 44 4 )
        , ( "^", CharInfo 123 44 3 )
        , ( "J", CharInfo 0 55 4 )
        , ( "у", CharInfo 5 55 3 )
        , ( "ю", CharInfo 9 55 5 )
        , ( "э", CharInfo 15 55 3 )
        , ( "т", CharInfo 19 55 3 )
        , ( "]", CharInfo 23 55 2 )
        , ( "F", CharInfo 26 55 3 )
        , ( "R", CharInfo 30 55 4 )
        , ( "M", CharInfo 35 55 5 )
        , ( "V", CharInfo 41 55 4 )
        , ( "B", CharInfo 46 55 4 )
        , ( "gj", CharInfo 51 55 5 )
        , ( "fj", CharInfo 57 55 4 )
        , ( "ц", CharInfo 62 55 4 )
        , ( "ч", CharInfo 67 55 3 )
        , ( "ъ", CharInfo 71 55 4 )
        , ( "ff", CharInfo 76 55 6 )
        , ( "C", CharInfo 83 55 4 )
        , ( "W", CharInfo 88 55 7 )
        , ( "N", CharInfo 96 55 4 )
        , ( "Z", CharInfo 101 55 4 )
        , ( "\\", CharInfo 106 55 4 )
        , ( "i", CharInfo 111 55 1 )
        , ( "A", CharInfo 113 55 4 )
        , ( "U", CharInfo 118 55 4 )
        , ( "ь", CharInfo 123 55 3 )
        , ( "ё", CharInfo 0 66 3 )
        , ( "х", CharInfo 4 66 3 )
        , ( "ф", CharInfo 8 66 5 )
        , ( "ы", CharInfo 14 66 5 )
        , ( "T", CharInfo 20 66 5 )
        , ( "@", CharInfo 26 66 7 )
        , ( "h", CharInfo 34 66 3 )
        , ( "[", CharInfo 38 66 2 )
        , ( "O", CharInfo 41 66 4 )
        ]


spriteSrc : String
spriteSrc =
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACAAQAAAADrRVxmAAADeklEQVR4nO2SXWgcVRiGn/my26wh6lZakkBSttWLINhu/CmBhDqtbemVWilaq9TgH4rSFtQ2gtij9aKX4h9UQfdCe9PQJCptaKMZWpqKWhyQxlRMMw2GBDXu5IdksrMznxdJmo0ogtd5Lx/O+Xi+c15LWRrhILrX8773gQAeF0ANTKQBUCPvNT5y4tWfv2zxR7b1Ne90kXOQtLrP5eL9nWZd8uioOFmYsbGiNwIyaHWiBSjPiCZr9uFhIbfR1kLswdhz01u9NEQaRjqjX+VHVFVjFUgAxKQBLGNFQixByvGy2TlVVVVt1+tBxx/b0xCcOHTPS2vO5s83qJiKm81n76K5YGdzuuq4Kx/YRGTpAO1pM4xKS648ePISWcgGUEA8ezZ1/C4AF2WbL9jjRxQyAIrjS/NGrI2X+jTsy9zwJmEG1cOqGqkOxKfbVVUWXpJ1czvI4vOG5zsASyG2rHkWC2KmbumqdIqv153j10+a3AmxC8/IkAMPnKLC/Xg0KQUbTtbn+hPsTqct20idE7q7HtqpEdGmWulHkiaZtZKTs2U0dbvJGz8SscGElakiFxorg1uflcu9IZk/O02DKft8dZMHPVqSUFWc0i4k5kz/1o/5uAA+f4jafHPVH+9o69b+M4CowXe9cvwiFH1WiTs5llrvfTg1dPppJyg6yLXWvdTeO1Zx7ZUdZxjqwjpZjKvWs7LdiZy27+o23SdKWTBmtdqxbajtOeLIbjZXlR1bd4rIhMSNcEg1XnSfUeb+YCF5/Xf168At7puKbH3n7V/AHLvYKD6kyg7qcD3Aj/mX5axL3ejvYS5+rbBqmtQuyXk8deDyBZuguIUobcv9/hT6gs2Vo2yhrN6IpGthNWx4i6/BQTIDTtRa0RFCnPj0jisOqj2qGh1WndEorypgL1qlS001w/T1ri9kUDXhp3X77du/fb46vrs5nN4/IWDV2NbmgKib8pWjJMIvOpkunzw+vELpcS76wuyukV7tetCqMKxJgTBoarBsghysxZ0Ss9awNaik2o6vxolsSu4MHdjQpY634sXIWN3EqodVJ37qKcypJECBVKY+nDeeVVXV4R90/sQ/fcO4GXBLyBODkT9wenE/eXi9pwdKr+R28FuqFPSqKS4ZusdiSaz384+GUSG7SHRQ8yUFUQGkVC4B3LRkxn83aBksg2Xw/8Ff2lQEUVlbcagAAAAASUVORK5CYII="
