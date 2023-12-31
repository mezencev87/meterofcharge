#Область ОбработчикиСобытийФормы

// Код процедур и функций

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПредполагаемыйПериод = Новый СтандартныйПериод(Объект.НачалоДействия, Объект.ОкончаниеДействия);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УслугаПриИзменении(Элемент)
	ОбновитьСписокПоставщиков(Объект.Услуга);
КонецПроцедуры

&НаКлиенте
Процедура ПредполагаемыйПериодПриИзменении(Элемент)
	Объект.НачалоДействия = ПредполагаемыйПериод.ДатаНачала;
	Объект.ОкончаниеДействия = ПредполагаемыйПериод.ДатаОкончания;
	ПроверитьПериодДействия();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы //<ИмяТаблицыФормы>

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

// Код процедур и функций
&НаКлиенте
Асинх Процедура ЗаполнитьКолонку(Команда)
	спВыбора = Новый СписокЗначений;
	спВыбора.Добавить("Все строки");
	спВыбора.Добавить("Только незаполненные");
	Обещание = ВыбратьИзМенюАсинх(спВыбора);
	Результат = Ждать Обещание;
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	фИгнорироватьДанные = (Результат.Значение = "Все строки");
	имяКолонки = СтрЗаменить(Элементы.ЦеныПоставщиков.ТекущийЭлемент.Имя, "ЦеныПоставщиков", "");
	Значение = Неопределено;
	Если Элементы.ЦеныПоставщиков.ТекущиеДанные.Свойство(имяКолонки, Значение) Тогда
		Для Каждого Строка Из Объект.ЦеныПоставщиков Цикл
			Если фИгнорироватьДанные Или Не ЗначениеЗаполнено(Строка[имяКолонки]) Тогда
				Строка[имяКолонки] = Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций
&НаСервере
Процедура ОбновитьСписокПоставщиков(Услуга)
	Элементы.ЦеныПоставщиковПоставщик.РежимВыбораИзСписка = Истина;
	Элементы.ЦеныПоставщиковПоставщик.СписокВыбора.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоставщикиОказываемыеУслуги.Ссылка КАК Поставщик,
	|	ПоставщикиОказываемыеУслуги.ЕдиницаИзмерения
	|ИЗ
	|	Справочник.Поставщики.ОказываемыеУслуги КАК ПоставщикиОказываемыеУслуги
	|ГДЕ
	|	ПоставщикиОказываемыеУслуги.Услуга = &Услуга
	|
	|УПОРЯДОЧИТЬ ПО
	|	Поставщик";

	Запрос.УстановитьПараметр("Услуга", Услуга);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовыйЭлемент = Элементы.ЦеныПоставщиковПоставщик.СписокВыбора.Добавить();
		НовыйЭлемент.Значение = ВыборкаДетальныеЗаписи.Поставщик;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПроверитьПериодДействия()
	Перем Сообщение;
	Перем Строка;
	Перем Индекс;
	Индекс = 0;
	ооПрайс = РеквизитФормыВЗначение("Объект");
	Для Каждого Строка Из Объект.ЦеныПоставщиков Цикл
		Если Строка.НачалоДействия < Объект.НачалоДействия Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "ЦеныПоставщиков[" + Индекс + "].НачалоДействия";
			Сообщение.УстановитьДанные(ооПрайс);
			Сообщение.Текст = "В строке " + (Индекс + 1) + " дата НачалаДействия меньше указанной в шапке документа";
			Сообщение.Сообщить();
		ИначеЕсли Строка.ОкончаниеДействия > Объект.ОкончаниеДействия Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле = "ЦеныПоставщиков[" + Индекс + "].ОкончаниеДействия";
			Сообщение.УстановитьДанные(ооПрайс);
			Сообщение.Текст = "В строке " + (Индекс + 1) + " дата ОкончанияДействия выходит за рамки указанного периода";
			Сообщение.Сообщить();
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти