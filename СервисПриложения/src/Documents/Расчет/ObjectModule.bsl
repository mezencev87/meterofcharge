
#Если Сервер Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Дата = ТекущаяДатаСеанса();
КонецПроцедуры

// Код процедур и функций
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.РасчетыЗаУслуги.Очистить();
	Движения.РасчетыЗаУслуги.Записать();
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыЗаУслугиОстатки.НаборУслуг,
	|	РасчетыЗаУслугиОстатки.ПоказанияОстаток КАК Показания,
	|	РасчетыЗаУслугиОстатки.БалансОстаток КАК Баланс
	|ИЗ
	|	РегистрНакопления.РасчетыЗаУслуги.Остатки(&ДатаРасчета, НаборУслуг В (&НаборыУслуг)) КАК РасчетыЗаУслугиОстатки";

	Запрос.УстановитьПараметр("НаборыУслуг", Расчеты.ВыгрузитьКолонку("НаборУслуг"));
	Запрос.УстановитьПараметр("ДатаРасчета", Дата);

	РезультатЗапроса = Запрос.Выполнить();

	ТаблицаОстатков = РезультатЗапроса.Выгрузить();
	тзНаборовУслуг = Расчеты.Выгрузить();
	тзНаборовУслуг.Свернуть("НаборУслуг");
	Для Каждого Строка Из тзНаборовУслуг Цикл
		Если ТаблицаОстатков.Найти(Строка.НаборУслуг) = Неопределено Тогда
			СтрокаОстатков = ТаблицаОстатков.Добавить();
			СтрокаОстатков.НаборУслуг = Строка.НаборУслуг;
			СтрокаОстатков.Показания = 0;
			СтрокаОстатков.Баланс = 0;
		КонецЕсли;
	КонецЦикла;
	НаборЗаписейЖурнала = РегистрыСведений.КорректировкиРасчетов.СоздатьНаборЗаписей();
	НаборЗаписейЖурнала.Отбор.Регистратор.Установить(Ссылка);
	НаборЗаписейЖурнала.Прочитать();
// регистр РасчетыЗаУслуги
	Движения.РасчетыЗаУслуги.Записывать = Истина;
	Индекс = Расчеты.Количество() - 1;
	НаборУслуг = Неопределено;
	Пока Индекс >= 0 Цикл
		ТекСтрокаРасчеты = Расчеты[Индекс];
		Индекс = Индекс - 1;
		РасходРесурса = 0;
		Если ТекСтрокаРасчеты.ВидРасчета = Перечисления.ВидыЦены.Фактическая Тогда
			РасходРесурса = ТекСтрокаРасчеты.ТекущиеПоказания - ТекСтрокаРасчеты.ПредыдущиеПоказания;
			РасходРесурсаРуб = Окр(РасходРесурса * ТекСтрокаРасчеты.Тариф, 2);
		Иначе
			РасходРесурсаРуб = Окр(ТекСтрокаРасчеты.КоличествоЧеловек * ТекСтрокаРасчеты.Тариф, 2);
		КонецЕсли;
		Если НаборУслуг <> ТекСтрокаРасчеты.НаборУслуг Тогда
			НаборУслуг = ТекСтрокаРасчеты.НаборУслуг;
			СтрокаОстатков = ТаблицаОстатков.Найти(НаборУслуг);
			НачальныеПоказания = СтрокаОстатков.Показания;
			НачальныйБаланс = СтрокаОстатков.Баланс;
		КонецЕсли;
#Область ФиксацияКорректировки
		КорректировкаПоказаний = ТекСтрокаРасчеты.ПредыдущиеПоказания - НачальныеПоказания;
		КорректировкаБаланса =  НачальныйБаланс + (ТекСтрокаРасчеты.Оплата - РасходРесурсаРуб - ТекСтрокаРасчеты.Баланс);
		Если КорректировкаПоказаний <> 0 Или КорректировкаБаланса <> 0 Тогда 
			//Запись корректировки по расчетам 
			РасчетыВызовСервера.ДобавитьДвижениеРасчетов(Движения, ТекСтрокаРасчеты.ОкончаниеПериода, НаборУслуг, Перечисления.ВидыЦены.Корректировка, 
				КорректировкаПоказаний, КорректировкаБаланса);
			НачальныеПоказания = НачальныеПоказания + КорректировкаПоказаний;
			НачальныйБаланс = НачальныйБаланс - КорректировкаБаланса;
		
			//фиксация факта корректировки
			фНовоеИзменение = Истина;
			Для Каждого Корректировка Из НаборЗаписейЖурнала Цикл
				Если Корректировка.НаборУслуг = НаборУслуг И Корректировка.ДельтаПоказаний = КорректировкаПоказаний
					И Корректировка.ДельтаБаланса = КорректировкаБаланса Тогда
					Если НачалоДня(ТекущаяДатаСеанса()) < Корректировка.МоментВремени Тогда
						//повторные записи не нужны, просто набиваем счетчик
						Корректировка.КоличествоПовторов = Корректировка.КоличествоПовторов + 1;
						Корректировка.Дельта = Корректировка.Дельта + (ТекущаяДатаСеанса()
							- Корректировка.МоментВремени);
						Корректировка.МоментВремени = ТекущаяДатаСеанса();
						фНовоеИзменение = Ложь;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			//запись нового факта корректировки
			Если фНовоеИзменение Тогда
				НоваяКорректировка = НаборЗаписейЖурнала.Добавить();
				НоваяКорректировка.МоментВремени = ТекущаяДатаСеанса();
				НоваяКорректировка.Регистратор = Ссылка;
				НоваяКорректировка.НаборУслуг = НаборУслуг;
				НоваяКорректировка.ДельтаПоказаний = КорректировкаПоказаний;
				НоваяКорректировка.ДельтаБаланса = КорректировкаБаланса;
			КонецЕсли;
		КонецЕсли;
#КонецОбласти

		//фиксация задолженности за ресурс по текущей сетке тарифа
		РасчетыВызовСервера.ДобавитьДвижениеРасчетов(Движения, ТекСтрокаРасчеты.ОкончаниеПериода, НаборУслуг, ТекСтрокаРасчеты.ВидРасчета, 
			0, - 1 * РасходРесурсаРуб);
		НачальныйБаланс = НачальныйБаланс - РасходРесурсаРуб;
		//Движение оплаты, положительно меняет баланс
		РасчетыВызовСервера.ДобавитьДвижениеРасчетов(Движения, ТекСтрокаРасчеты.ОкончаниеПериода, НаборУслуг, ТекСтрокаРасчеты.ВидРасчета, 
			РасходРесурса, ТекСтрокаРасчеты.Оплата);
		НачальныеПоказания = НачальныеПоказания + РасходРесурса;
		НачальныйБаланс = НачальныйБаланс + ТекСтрокаРасчеты.Оплата;
	КонецЦикла;
	НаборЗаписейЖурнала.Записать();
КонецПроцедуры

//@skip-check data-exchange-load
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Расчеты.Сортировать("НаборУслуг, ОкончаниеПериода Убыв, ПредыдущиеПоказания Убыв");
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Код процедур и функций

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти

#Область Инициализация

#КонецОбласти

#КонецЕсли