#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ВидРасчета") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ОкончаниеПериода,КоличествоЧеловек,ТекущиеПоказания,Тариф,
		|		Оплата,Баланс,ТекущийБаланс,ПредыдущиеПоказания,ВидРасчета,НомерСтроки");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.КнопОкончаниеПериода.Заголовок = Формат(ОкончаниеПериода, "ДФ='ММММ гггг'");
	Если ВидРасчета = ПредопределенноеЗначение("Перечисление.ВидыЦены.Нормативная") Тогда
		Элементы.КоличествоЧеловек.Видимость = Истина;
		Если ТекущиеПоказания = 0 Тогда
			ТекущиеПоказания = ПредыдущиеПоказания;
		КонецЕсли;
		Элементы.ТекущиеПоказания.Доступность = Ложь;
		ТекущийЭлемент = Элементы.Тариф;
	Иначе
		ТекущийЭлемент = Элементы.ТекущиеПоказания;
	КонецЕсли;
	РассчитатьБаланс(ТекущийБаланс);
	#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
	#КонецЕсли
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Асинх Процедура ТекущиеПоказанияПриИзменении(Элемент)
	Если ТекущиеПоказания < ПредыдущиеПоказания Тогда
		Ожидание = ВопросАсинх("Вы ввели показания меньше, чем на начало периода. Вы уверены?",
			РежимДиалогаВопрос.ДаНет);
		Результат = Ждать Ожидание;
		Если Результат = КодВозвратаДиалога.Нет Тогда
			ТекущийЭлемент = Элементы.ТекущиеПоказания;
	#Если МобильноеПриложениеКлиент Тогда
			НачатьРедактированиеЭлемента();
	#КонецЕсли
			Возврат;
		КонецЕсли;
	КонецЕсли;
	РассчитатьБаланс(ТекущийБаланс);
	ТекущийЭлемент = Элементы.Оплата;
	#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
	#КонецЕсли
	Элементы.ДекРасход.Заголовок = Строка(ТекущиеПоказания - ПредыдущиеПоказания);
КонецПроцедуры


&НаКлиенте
Процедура ОкончаниеПериодаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОкончаниеПериода = ВыбранноеЗначение;
	Элементы.КнопОкончаниеПериода.Заголовок = Формат(ОкончаниеПериода, "ДФ='ММММ гггг'");
	Элементы.ОкончаниеПериода.Видимость = Ложь;
	Элементы.ГруппаДата.Видимость = Истина;
	ОтключитьОбработчикОжидания("ПроверкаАктивностиВводаДаты");
КонецПроцедуры


&НаКлиенте
Процедура ВидРасчетаПриИзменении(Элемент)
	Если ВидРасчета = ПредопределенноеЗначение("Перечисление.ВидыЦены.Нормативная") Тогда
		Элементы.КоличествоЧеловек.Видимость = Истина;
		Если ТекущиеПоказания = 0 Тогда
			ТекущиеПоказания = ПредыдущиеПоказания;
		КонецЕсли;
		Элементы.ТекущиеПоказания.Доступность = Ложь;
		ТекущийЭлемент = Элементы.Тариф;
	Иначе
		ТекущийЭлемент = Элементы.ТекущиеПоказания;
		Элементы.ТекущиеПоказания.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ТарифПриИзменении(Элемент)
	РассчитатьБаланс(ТекущийБаланс);
	ТекущийЭлемент = Элементы.Оплата;
	#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОплатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Оплата = 0 И Баланс < 0 Тогда
		Оплата = -1 * Баланс;
		Элементы.Оплата.ОбновитьТекстРедактирования();
		РассчитатьБаланс(ТекущийБаланс);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОплатаПриИзменении(Элемент)
	РассчитатьБаланс(ТекущийБаланс);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Асинх Процедура ЗадатьДату(Команда)
	Элементы.ГруппаДата.Видимость = Ложь;
	Элементы.ОкончаниеПериода.Видимость = Истина;
	ТекущийЭлемент = Элементы.ОкончаниеПериода;
	#Если МобильноеПриложениеКлиент Тогда
		НачатьРедактированиеЭлемента();
	#КонецЕсли
	ПодключитьОбработчикОжидания("ПроверкаАктивностиВводаДаты", 1, Ложь);
КонецПроцедуры


&НаКлиенте
Процедура Готово(Команда)
	ОповеститьОВыборе(
		Новый Структура("ОкончаниеПериода,КоличествоЧеловек,ТекущиеПоказания,Тариф,Оплата,Баланс,ПредыдущиеПоказания,
		|	ВидРасчета,НомерСтроки",
		ОкончаниеПериода, ТекущиеПоказания, Тариф, Оплата, Баланс, ПредыдущиеПоказания, ВидРасчета, НомерСтроки));
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьБаланс(Команда)
	РассчитатьБаланс(0);
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ПроверкаАктивностиВводаДаты()
	Если Элементы.ОкончаниеПериода <> ТекущийЭлемент Тогда
		Элементы.КнопОкончаниеПериода.Заголовок = Формат(ОкончаниеПериода, "ДФ='ММММ гггг'");
		Элементы.ОкончаниеПериода.Видимость = Ложь;
		Элементы.ГруппаДата.Видимость = Истина;
		ОтключитьОбработчикОжидания("ПроверкаАктивностиВводаДаты");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьБаланс(ВходящийБаланс)
	Баланс = ВходящийБаланс + Оплата;
	Если ВидРасчета = ПредопределенноеЗначение("Перечисление.ВидыЦены.Фактическая") Тогда
		Если ТекущиеПоказания > 0 Тогда
			Баланс = Баланс - Тариф * (ТекущиеПоказания - ПредыдущиеПоказания);
		КонецЕсли;
	Иначе
		Баланс = Баланс - КоличествоЧеловек * Тариф;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти