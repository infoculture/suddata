Описание
--
Код, данные и промежуточные результаты по анализу базы судебных актов с DYIjustice.ru

Первичная база - 150GB в запакованном виде поэтому здесь только списки файлов и преобразованные данные


Папки
-----
* torrent - торрент с первичной выгрузкой
* listing - списки файлов из оригинального торрент-трекера
* examples - выборка в несколько мегабайт XML файлов распакованная из оригинального архива
* scripts - скрипты

Нужна помощь
---

В папке examples лежит множество XML файлов которые включают несколько тегов и финальный тег body в котором текст решения в виде HTML.
Нужен скрипт, желательно на чем-то несложном (Python, Ruby, sed/awk/sh и тд) который бы проходил по всем папкам и сохранял бы все атрибуты кроме body в CSV файл, а из XML файла вырезал бы поле body и складывал бы в виде html файла. В CSV файл надо также добавить ID из названия файла чтобы можно было бы сопоставить конкретный HTML документ и запись в CSV

Скрипт можно сразу контрибьютить в этот репозиторий.


TODO
----
* преобразовать данные. Извлечь метаданные и сохранить в CSV и JSON. Отдельно сохранить все оригинальные документы в HTML (те что в теге body)
* описать формат данных в Wiki github
* выложить все данные в открытый доступ на Hubofdata.ru и других ресурсах
* загрузить данные в MongoDB или другую СУБД и сделать дамп базы целиком для распространения


 
