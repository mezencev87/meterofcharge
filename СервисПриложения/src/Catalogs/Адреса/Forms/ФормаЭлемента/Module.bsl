#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Объект.Наименование) Тогда
		Элементы.ГруппаАдрес.Видимость = Ложь;
	КонецЕсли;
	ОбновитьПоляАдреса();
	Элементы.РучноеНаименование.Видимость = Объект.РучноеНаименование;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновлениеДанных");
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Объект.Наименование = Элемент.ТекстРедактирования;
	ДанныеВыбора = Новый СписокЗначений;
	СписокВыбора.Очистить();
	Для Каждого Строка Из СформироватьПодсказкиПоАдресам(Объект.Наименование) Цикл
		ДанныеВыбора.Добавить(Строка.Подсказка);
		новоеЗначение = СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(новоеЗначение, Строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура АвтоПодборПоляАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	СписокВыбора.Очистить();
	Для Каждого Строка Из СформироватьПодсказкиПоАдресам(Текст, Элемент.Имя) Цикл
		ДанныеВыбора.Добавить(Строка.Подсказка);
		новоеЗначение = СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(новоеЗначение, Строка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Объект.Наименование = ВыбранноеЗначение;
	строки = СписокВыбора.НайтиСтроки(Новый Структура("Подсказка", ВыбранноеЗначение));
	Если строки.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект, строки[0]);
	КонецЕсли;
	Объект.РучноеНаименование = Ложь;
	Элементы.РучноеНаименование.Видимость = Объект.РучноеНаименование;
	ПодключитьОбработчикОжидания("ОбновитьПоляАдреса", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПоляАдреса(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	строки = СписокВыбора.НайтиСтроки(Новый Структура("Подсказка", ВыбранноеЗначение));
	Если строки.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект, строки[0]);
		Если НЕ Объект.РучноеНаименование Тогда
			Объект.Наименование = строки[0].Подсказка;
		КонецЕсли;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьПоляАдреса", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПоляАдреса(Элемент)
	строки = СписокВыбора.НайтиСтроки(Новый Структура(Элемент.Имя, Элемент.ТекстРедактирования));
	Если строки.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Объект, строки[0]);
		Если НЕ Объект.РучноеНаименование Тогда
			Объект.Наименование = строки[0].Подсказка;
		КонецЕсли;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьПоляАдреса", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КвартираПриИзменении(Элемент)
	Если СтрНайти(Объект.ПолныйАдрес, ", кв ") Тогда
		Объект.ПолныйАдрес = Лев(Объект.ПолныйАдрес, СтрНайти(Объект.ПолныйАдрес, ", кв ")) + " кв " + Объект.Квартира;
	Иначе
		Объект.ПолныйАдрес = Объект.ПолныйАдрес + ", кв " + Объект.Квартира;
	КонецЕсли;
	строки = СформироватьПодсказкиПоАдресам(Объект.ПолныйАдрес);
	Если строки.Количество() > 0 Тогда
		Объект.Код = строки[0].Код;
		Если НЕ Объект.РучноеНаименование Тогда
			Объект.Наименование = строки[0].Подсказка;
		КонецЕсли;
		Если Не строки[0].Действителен Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Квартира с таким номером не обнаружена в базе данных ФИАС";
			Сообщение.ПутьКДанным = "Объект.Квартира";
			Сообщение.УстановитьДанные(Объект);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьПоляАдреса", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Объект.РучноеНаименование = Истина;
	Элементы.РучноеНаименование.Видимость = Объект.РучноеНаименование;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы //<ИмяТаблицыФормы>

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОтобразитьПоляАдреса(Команда)
	Если Элементы.ГруппаАдрес.Видимость Тогда
		Элементы.ГруппаАдрес.Видимость = Ложь;
		Если ЗначениеЗаполнено(Объект.ПолныйАдрес) Тогда
			Элементы.ОтобразитьПоляАдреса.Заголовок = "Показать поля адреса (" + Объект.ПолныйАдрес + ")";
		Иначе
			Элементы.ОтобразитьПоляАдреса.Заголовок = "Показать поля адреса (не задан)";
		КонецЕсли;
	Иначе
		Элементы.ГруппаАдрес.Видимость = Истина;
		ПодключитьОбработчикОжидания("ОбновитьПоляАдреса", 0.1, Истина);
	КонецЕсли;		
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбновитьПоляАдреса()
	Элементы.ОтобразитьПоляАдреса.Заголовок = ?(Элементы.ГруппаАдрес.Видимость, "Скрыть ", "Показать ");
	Если ЗначениеЗаполнено(Объект.ПолныйАдрес) Тогда
		Элементы.ОтобразитьПоляАдреса.Заголовок = Элементы.ОтобразитьПоляАдреса.Заголовок + 
				"поля адреса (" + Объект.ПолныйАдрес + ")";
	Иначе
		Элементы.ОтобразитьПоляАдреса.Заголовок = Элементы.ОтобразитьПоляАдреса.Заголовок + 
				"поля адреса (не задан)";
	КонецЕсли;
	ОбновитьОтображениеДанных();
	Элементы.Наименование.ОбновитьТекстРедактирования();
	Элементы.Код.ОбновитьТекстРедактирования();
	Элементы.Регион.ОбновитьТекстРедактирования();
	Элементы.Район.ОбновитьТекстРедактирования();
	Элементы.Город.ОбновитьТекстРедактирования();
	Элементы.НаселенныйПункт.ОбновитьТекстРедактирования();
	Элементы.Улица.ОбновитьТекстРедактирования();
	Элементы.Дом.ОбновитьТекстРедактирования();
	Элементы.Квартира.ОбновитьТекстРедактирования();
КонецПроцедуры


&НаКлиенте
Функция СформироватьПодсказкиПоАдресам(ТекстЗапроса, ПолеЗапроса = "")
	СоединениеСРесурсом = Новый HTTPСоединение("suggestions.dadata.ru", , , , , , Новый ЗащищенноеСоединениеOpenSSL);
	Заголовки = Новый Соответствие;

	ЗапросКРесурсу = Новый HTTPЗапрос("/suggestions/api/4_1/rs/suggest/address", Заголовки);
	ЗапросКРесурсу.Заголовки.Вставить("Content-Type", "application/json");
	ЗапросКРесурсу.Заголовки.Вставить("Accept", "application/json");
	ЗапросКРесурсу.Заголовки.Вставить("Authorization", "Token 0e533949abc3edbda7afaeba7b9d9295b3b9c207");
	ТелоЗапроса = СформироватьСообщениеЗапроса(ТекстЗапроса, ПолеЗапроса);
	ЗапросКРесурсу.УстановитьТелоИзСтроки(ТелоЗапроса, "utf-8");

	ОтветРесурса = СоединениеСРесурсом.ВызватьHTTPМетод("POST", ЗапросКРесурсу);

	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ОтветРесурса.ПолучитьТелоКакСтроку());

	Попытка
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON);
	Исключение
		Сообщить("Ошибка при выставлении счёта");
	КонецПопытки;

	ПринятыеДанные = Новый Массив;
	РезультатЗапроса = Новый Массив;
	Если ОтветОбъект.Свойство("suggestions", ПринятыеДанные) Тогда
		Для Каждого Элемент Из ПринятыеДанные Цикл
			стРезультат = Новый Структура("Подсказка,ПочтовыйИндекс,Регион,Район,Город,НаселенныйПункт,Улица,
										  |	Дом,Квартира,Код,ПолныйАдрес,Действителен");
			стРезультат.ПочтовыйИндекс = Элемент.data.postal_code;
			стРезультат.Код = Элемент.data.fias_id;
			стРезультат.Регион = Элемент.data.region;
			стРезультат.Район = Элемент.data.area;
			стРезультат.Город = Элемент.data.city;
			стРезультат.НаселенныйПункт = Элемент.data.settlement;
			стРезультат.Улица = Элемент.data.street;
			стРезультат.Дом = Элемент.data.house;
			стРезультат.Квартира = Элемент.data.flat;
			Наименование = "";
			Если ЗначениеЗаполнено(стРезультат.НаселенныйПункт) Тогда
				Наименование = стРезультат.НаселенныйПункт;
			ИначеЕсли ЗначениеЗаполнено(стРезультат.Город) Тогда
				Наименование = стРезультат.Город;
			КонецЕсли;
			Если ЗначениеЗаполнено(стРезультат.Улица) Тогда
				Наименование = Наименование + ", " + стРезультат.Улица;
			КонецЕсли;
			Если ЗначениеЗаполнено(стРезультат.Дом) Тогда
				Наименование = Наименование + ", " + стРезультат.Дом;
			КонецЕсли;
			Если ЗначениеЗаполнено(стРезультат.Квартира) Тогда
				Если Элемент.data.flat_fias_id = Неопределено Тогда
					стРезультат.Действителен = Ложь;
				Иначе
					стРезультат.Действителен = Истина;
				КонецЕсли;
				Наименование = Наименование + " - " + стРезультат.Квартира;
			КонецЕсли;
			Если ЗначениеЗаполнено(Наименование) И ПолеЗапроса <> "НаселенныйПункт" И ПолеЗапроса <> "Город" Тогда
				стРезультат.Подсказка = Наименование;
			Иначе
				стРезультат.Подсказка = Элемент.value;
			КонецЕсли;
			стРезультат.ПолныйАдрес = Элемент.unrestricted_value;
			РезультатЗапроса.Добавить(стРезультат);
		КонецЦикла;
	КонецЕсли;

	Возврат РезультатЗапроса;
КонецФункции

&НаКлиенте
Функция СформироватьСообщениеЗапроса(ТекстЗапроса, ПолеЗапроса)
	Перем ЗаписьСообщения;
	Перем Значение;
	Перем МассивПолей;
	ЗаписьСообщения = Новый ЗаписьJSON;
	ЗаписьСообщения.УстановитьСтроку();
	ЗаписьСообщения.ЗаписатьНачалоОбъекта();
		
		//Запись ограничений поиска
		Если ПолеЗапроса <> "" Тогда
		//Запись ограничения зоны поиска по уже заданным полям
			МассивПолей = Новый Массив;
			Если ЗначениеЗаполнено(Объект.Регион) И ПолеЗапроса <> "Регион" Тогда
				МассивПолей.Добавить(Новый Структура("Имя,Значение", "region", Объект.Регион));
			КонецЕсли;
			Если ЗначениеЗаполнено(Объект.Район) И ПолеЗапроса <> "Район" Тогда
				МассивПолей.Добавить(Новый Структура("Имя,Значение", "area", Объект.Район));
			КонецЕсли;
			Если ЗначениеЗаполнено(Объект.Город) И ПолеЗапроса <> "Город" Тогда
				МассивПолей.Добавить(Новый Структура("Имя,Значение", "city", Объект.Город));
			КонецЕсли;
			Если ЗначениеЗаполнено(Объект.НаселенныйПункт) И ПолеЗапроса <> "НаселенныйПункт" Тогда
				МассивПолей.Добавить(Новый Структура("Имя,Значение", "settlement", Объект.НаселенныйПункт));
			КонецЕсли;
			Если ЗначениеЗаполнено(Объект.Улица) И ПолеЗапроса <> "Улица" Тогда
				МассивПолей.Добавить(Новый Структура("Имя,Значение", "street", Объект.Улица));
			КонецЕсли;
			Если МассивПолей.Количество() > 0 Тогда
				ЗаписьСообщения.ЗаписатьИмяСвойства("locations");
				ЗаписьСообщения.ЗаписатьНачалоМассива();
				ЗаписьСообщения.ЗаписатьНачалоОбъекта();
				Для Каждого Элемент Из МассивПолей Цикл
					ЗаписьСообщения.ЗаписатьИмяСвойства(Элемент.Имя);
					ЗаписьСообщения.ЗаписатьЗначение(Элемент.Значение);
				КонецЦикла;
				ЗаписьСообщения.ЗаписатьКонецОбъекта();
				ЗаписьСообщения.ЗаписатьКонецМассива();
				ЗаписьСообщения.ЗаписатьИмяСвойства("restrict_value");
				ЗаписьСообщения.ЗаписатьЗначение(Истина);
			КонецЕсли;
			//ограничение по полю поиска
			ЗаписьСообщения.ЗаписатьИмяСвойства("from_bound");
			ЗаписьСообщения.ЗаписатьНачалоОбъекта();
				ЗаписьСообщения.ЗаписатьИмяСвойства("value");
				Если ПолеЗапроса = "Улица" Тогда
					Значение = "street";
				ИначеЕсли ПолеЗапроса = "НаселенныйПункт" Тогда
					Значение = "settlement";
				ИначеЕсли ПолеЗапроса = "Город" Тогда
					Значение = "city";
				ИначеЕсли ПолеЗапроса = "Район" Тогда
					Значение = "area";
				ИначеЕсли ПолеЗапроса = "Регион" Тогда
					Значение = "region";
				ИначеЕсли ПолеЗапроса = "Дом" Тогда
					Значение = "house";
				КонецЕсли;
				ЗаписьСообщения.ЗаписатьЗначение(Значение);
			ЗаписьСообщения.ЗаписатьКонецОбъекта();
			ЗаписьСообщения.ЗаписатьИмяСвойства("to_bound");
			ЗаписьСообщения.ЗаписатьНачалоОбъекта();
				ЗаписьСообщения.ЗаписатьИмяСвойства("value");
				ЗаписьСообщения.ЗаписатьЗначение(Значение);
			ЗаписьСообщения.ЗаписатьКонецОбъекта();
			Если ПолеЗапроса = "Улица" Тогда
				ЗаписьСообщения.ЗаписатьИмяСвойства("count");
				ЗаписьСообщения.ЗаписатьЗначение(20);
			КонецЕсли;	
		КонецЕсли;
		
		//Запись текста запроса
		ЗаписьСообщения.ЗаписатьИмяСвойства("query");
		ЗаписьСообщения.ЗаписатьЗначение(ТекстЗапроса);
		
	ЗаписьСообщения.ЗаписатьКонецОбъекта();
	Возврат ЗаписьСообщения.Закрыть();
КонецФункции
#КонецОбласти