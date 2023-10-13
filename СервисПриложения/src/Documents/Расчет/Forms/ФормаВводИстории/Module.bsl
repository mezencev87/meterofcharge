
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Расчеты.Количество() > 0 Тогда
		ВидРасчета = Объект.Расчеты[0].ВидРасчета;
		Если ВидРасчета = Перечисления.ВидыЦены.Нормативная Тогда
			Элементы.РасчетыПредыдущиеПоказания.Видимость = Ложь;
		Иначе
			Элементы.РасчетыКоличествоЧеловек.Видимость = Ложь;
		КонецЕсли;
		НаборУслуг = Объект.Расчеты[0].НаборУслуг;
	Иначе
		ВидРасчета = Перечисления.ВидыЦены.Фактическая;
		Элементы.РасчетыКоличествоЧеловек.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		Оповестить("ОбновлениеДанных");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	СтрокаТЧ = Объект.Расчеты[ИсточникВыбора.НомерСтроки - 1];
	ЗаполнитьЗначенияСвойств(СтрокаТЧ, ИсточникВыбора);
	Элементы.Расчеты.ТекущаяСтрока = СтрокаТЧ.ПолучитьИдентификатор();
	Объект.Расчеты.Сортировать("ОкончаниеПериода Убыв");
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ВидРасчетаПриИзменении(Элемент)
	Если ВидРасчета = ПредопределенноеЗначение("Перечисление.ВидыЦены.Нормативная") Тогда
		Элементы.РасчетыПредыдущиеПоказания.Видимость = Ложь;
		Элементы.РасчетыКоличествоЧеловек.Видимость = Истина;
	Иначе
		Элементы.РасчетыПредыдущиеПоказания.Видимость = Истина;
		Элементы.РасчетыКоличествоЧеловек.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасчеты
&НаКлиенте
Процедура РасчетыТарифПриИзменении(Элемент)
	РассчитатьБаланс();
КонецПроцедуры

&НаКлиенте
Процедура РасчетыОкончаниеПериодаПриИзменении(Элемент)
	Объект.Расчеты.Сортировать("ОкончаниеПериода Убыв");
КонецПроцедуры

&НаКлиенте
Процедура РасчетыТекущиеПоказанияПриИзменении(Элемент)
	РассчитатьБаланс();
КонецПроцедуры

&НаКлиенте
Процедура РасчетыОплатаПриИзменении(Элемент)
	РассчитатьБаланс();
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Изменить(Команда)
	стПараметры = Новый Структура("ОкончаниеПериода,КоличествоЧеловек,ТекущиеПоказания,Тариф,Оплата,Баланс,
	|	ТекущийБаланс,ПредыдущиеПоказания,ВидРасчета,НомерСтроки");
	ЗаполнитьЗначенияСвойств(стПараметры, Элементы.Расчеты.ТекущиеДанные);
	ТекущийБаланс = 0;
	Для Каждого Элемент Из Объект.Расчеты Цикл
		Если Элемент.ОкончаниеПериода < Элементы.Расчеты.ТекущиеДанные.ОкончаниеПериода Тогда
			ТекущийБаланс = Элемент.Баланс;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	стПараметры.ТекущийБаланс = ТекущийБаланс;
	ОткрытьФорму("Документ.Расчет.Форма.ФормаСтроки", стПараметры, ЭтотОбъект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НоваяЗапись(Команда)
	Если Не (ЗначениеЗаполнено(НаборУслуг) Или ЗначениеЗаполнено(ВидРасчета)) Тогда
		Сообщить("Сперва укажите услугу и основной вид расчета!");
		Возврат;
	КонецЕсли;
	Если Объект.Расчеты.Количество() > 0 Тогда
		НоваяСтрока = Объект.Расчеты.Вставить(0);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Объект.Расчеты[1]);
		ЗаполнитьНовуюСтроку(НоваяСтрока, Истина);
	Иначе
		НоваяСтрока = Объект.Расчеты.Вставить(0);
		ЗаполнитьНовуюСтроку(НоваяСтрока, Ложь);
	КонецЕсли;
	стПараметры = Новый Структура("ОкончаниеПериода,КоличествоЧеловек,ТекущиеПоказания,Тариф,Оплата,Баланс,
	|	ТекущийБаланс,ПредыдущиеПоказания,ВидРасчета,НомерСтроки");
	ЗаполнитьЗначенияСвойств(стПараметры, НоваяСтрока, , "НомерСтроки");
	стПараметры.НомерСтроки = 1;
	стПараметры.ТекущийБаланс = НоваяСтрока.Баланс;
	ОткрытьФорму("Документ.Расчет.Форма.ФормаСтроки", стПараметры, ЭтотОбъект, , , , ,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
#КонецОбласти


#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура РассчитатьБаланс()
	Строка = Элементы.Расчеты.ТекущиеДанные;
	Баланс = 0;
	Для Каждого Элемент Из Объект.Расчеты Цикл
		Если Элемент.ОкончаниеПериода < Строка.ОкончаниеПериода Тогда
			Баланс = Элемент.Баланс;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Строка.Баланс = Баланс + Строка.Оплата - ?(Строка.ВидРасчета = ПредопределенноеЗначение(
		"Перечисление.ВидыЦены.Фактическая"), Строка.Тариф * (Строка.ТекущиеПоказания - Строка.ПредыдущиеПоказания),
		Строка.КоличествоЧеловек * Строка.Тариф);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНовуюСтроку(НоваяСтрока, Копирование)
	Перем СтрокаБаланса;
	Перем МесяцРасчета;
	НоваяСтрока.ВидРасчета = ВидРасчета;
	НоваяСтрока.НаборУслуг = НаборУслуг;
	Если ЗначениеЗаполнено(НоваяСтрока.ОкончаниеПериода) Тогда
		МесяцРасчета = КонецМесяца(НоваяСтрока.ОкончаниеПериода) + 777600;
	Иначе
		МесяцРасчета = ТекущаяДата();
	КонецЕсли;
	НоваяСтрока.ОкончаниеПериода = МесяцРасчета;
	СтрокаБаланса = НоваяСтрока;
	Для Каждого СтрокаРасчета Из Объект.Расчеты Цикл
		Если СтрокаРасчета.ОкончаниеПериода < НоваяСтрока.ОкончаниеПериода Тогда
			СтрокаБаланса = СтрокаРасчета;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Копирование Тогда
		НоваяСтрока.НачалоПериода = СтрокаБаланса.ОкончаниеПериода - 86400;
		НоваяСтрока.Оплата = 0;
		НоваяСтрока.ПредыдущиеПоказания = СтрокаБаланса.ТекущиеПоказания;
		НоваяСтрока.ТекущиеПоказания = 0;
	КонецЕсли;
	НоваяСтрока.Тариф = РасчетыВызовСервера.ТарифДляНабораУслуг(НаборУслуг, ВидРасчета, НоваяСтрока.ОкончаниеПериода);
		//Проверка заполненности важных значений
	Если НоваяСтрока.Тариф = 0 Тогда
		НоваяСтрока.Тариф = СтрокаБаланса.Тариф;
	КонецЕсли;
	Если НоваяСтрока.КоличествоЧеловек = 0 Тогда
		НоваяСтрока.КоличествоЧеловек = 1;
	КонецЕсли;
	Объект.Расчеты.Сортировать("ОкончаниеПериода Убыв");
КонецПроцедуры
#КонецОбласти