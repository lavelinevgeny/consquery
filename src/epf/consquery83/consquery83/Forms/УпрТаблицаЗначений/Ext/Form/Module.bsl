﻿&НаКлиенте
Перем ИмяКолонкиПоУмолчанию;

#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЭлементыформыПоЗначению(Параметры.Значение);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НастройкиТаблицыЗначенийТипКолонкиПриИзменении(Элемент)

	ТекущаяКолонка 	= Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;
	ИзменитьКолонкуСервер(ТекущаяКолонка.Имя, ТекущаяКолонка.ТипЗначения);
	                                                                              
КонецПроцедуры


&НаКлиенте
Процедура НастройкиТаблицыЗначенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;

	ИмяКолонки = гПолучитьУникальноеИмяВКоллекции(ИмяКолонкиПоУмолчанию, НастройкиТаблицыЗначений, "Имя");
	
    ЭлементНастройки = НастройкиТаблицыЗначений.Добавить();
	ЭлементНастройки.Имя        = ИмяКолонки;
	ЭлементНастройки.ТипЗначения = ТипЗначенияСтрока();
	
	ДобавитьКолонкуНаФорму(ЭлементНастройки.Имя, ЭлементНастройки.ТипЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийНаименованиеКолонкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)

	НовоеИмя = гПолучитьУникальноеИмяВКоллекции(СокрЛП(Текст), НастройкиТаблицыЗначений, "Имя");
	
	ТекущаяКолонка 	= Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;

	ИзменитьКолонкуСервер(НовоеИмя, ТекущаяКолонка.ТипЗначения, ТекущаяКолонка.Имя);
	
	Элементы.НастройкиТаблицыЗначений.ТекущиеДанные.Имя = НовоеИмя;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТаблицыЗначенийПередУдалением(Элемент, Отказ)
	
	ТекущаяСтрока 	 = Элементы.НастройкиТаблицыЗначений.ТекущаяСтрока;
	ТекущаяКолонкаТЗ = Элементы.НастройкиТаблицыЗначений.ТекущиеДанные;
	ИмяКолонки 		 = ТекущаяКолонкаТЗ.Имя;
	
	УдалитьКолонкуСервер(ИмяКолонки);
	
	ЭлементКоллекции        = НастройкиТаблицыЗначений.НайтиПоИдентификатору(ТекущаяСтрока);
	ИндексЭлементаКоллекции = НастройкиТаблицыЗначений.Индекс(ЭлементКоллекции);
	
	НастройкиТаблицыЗначений.Удалить(ИндексЭлементаКоллекции);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

&НаКлиенте
Процедура ЗаписатьТаблицуЗначений(Команда)
	ЗаписатьТаблицуЗначенийСервер();	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ПреобразоватьВПравильноеНазваниеНаСервере(Имя)
	Возврат ОбъектОбработки().гПреобразоватьВПравильноеНазвание(Имя)
КонецФункции // ПреобразоватьВПравильноеНазваниеНаСервере()

&НаСервереБезКонтекста
Функция гПолучитьУникальноеИмяВКоллекции(ИсходноеИмя, Коллекция, ИмяПоля = Неопределено)
	Возврат ОбъектОбработки().гПолучитьУникальноеИмяВКоллекции(ИсходноеИмя, Коллекция, ИмяПоля)
КонецФункции // ПреобразоватьВПравильноеНазваниеНаСервере()

// Формирует колонки для Таблицы значений из Настроек таблицы значений.
//
// Изменяет реквизиты текущего параметра.
//
&НаКлиенте
Процедура ЗаписатьТаблицуЗначенийСервер()

	Закрыть(); 
	Владелец					= ЭтотОбъект.ВладелецФормы;
	Владелец.Модифицированность = Истина;
	
	Оповестить("ОбновитьПараметрСТаблицейЗначений", РезультатВСтрокуВнутр());
КонецПроцедуры	 // ЗаписатьТаблицуЗначенийСервер()

// Заполняет таблицы значений в форме по загружаемой таблице значений.
//
&НаСервере
Процедура ЗаполнитьЭлементыформыПоЗначению(ТаблицаЗначенийXML)

	ТаблицаЗначенийВходящая = ЗначениеИзСтроки(ТаблицаЗначенийXML);
	
	Если ТипЗнч(ТаблицаЗначенийВходящая) <> Тип("ТаблицаЗначений") Тогда
		ВызватьИсключение "В форму передано некорректное значение : ";
	КонецЕсли;	

	Колонки = ТаблицаЗначенийВходящая.Колонки;
	
	Для Каждого Колонка Из Колонки Цикл 

		Настройка = НастройкиТаблицыЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(Настройка, Колонка);
		
		Если Не Настройка.ТипЗначения.Типы().Количество() Тогда 
		    Настройка.ТипЗначения = ТипЗначенияСтрока();
		КонецЕсли;
		
		ДобавитьКолонкуНаФорму(Настройка.Имя, Настройка.ТипЗначения);
		
	КонецЦикла;	
	
	ТаблицаЗначенийПараметр.Загрузить(ТаблицаЗначенийВходящая.Скопировать());
	
КонецПроцедуры // ЗаполнитьЭлементыформыПоЗначению()	

Функция ИмяЭлемента(ИмяПоля)
	
	Возврат СтрШаблон("%1%2", ИмяЭлементаТЗ(), ИмяПоля);
	
КонецФункции

Функция ПутьДляПоля(ИмяПоля)
	
	Возврат СтрШаблон("%1.%2", ИмяЭлементаТЗ(), ИмяПоля);
	
КонецФункции

&НаСервере
Процедура ДобавитьКолонкуНаФорму(Имя, Знач ТипЗначения)

	МассивДобавляемыхЭлементов = Новый Массив;
	
	РеквизитКолонка = Новый РеквизитФормы(Имя, ТипЗначения, ИмяЭлементаТЗ(), Имя);
	МассивДобавляемыхЭлементов.Добавить(РеквизитКолонка);
	
	ИзменитьРеквизиты(МассивДобавляемыхЭлементов);
	
	НовыйЭлемент = Элементы.Добавить(ИмяЭлемента(Имя), Тип("ПолеФормы"), Элементы[ИмяЭлементаТЗ()]);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = ПутьДляПоля(Имя);
	НовыйЭлемент.Ширина = 10;	

КонецПроцедуры // ДобавитьКолонкуНаФорму()

// Удаляет колонку по имени.
//
// Параметры:
//	ИмяКолонки - имя колонки.
//
Процедура УдалитьКолонкуСервер(Имя)
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	МассивУдаляемыхРеквизитов.Добавить(ПутьДляПоля(Имя));
	ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);

	Элементы.Удалить(Элементы[ИмяЭлемента(Имя)]);
	
КонецПроцедуры	

Процедура ИзменитьКолонкуСервер(Знач Имя, Тип, Знач СтароеИмя = "")

	Если ПустаяСтрока(СтароеИмя) Тогда 
		СтароеИмя = Имя;
	КонецЕсли;

	ДанныеИзменяемойКолонки = ТаблицаЗначенийПараметр.Выгрузить().ВыгрузитьКолонку(СтароеИмя);
	
	УдалитьКолонкуСервер(СтароеИмя);
	ДобавитьКолонкуНаФорму(Имя, Тип);
	
	ТаблицаЗначенийВрем = РеквизитФормыВЗначение(ИмяЭлементаТЗ());
	ТаблицаЗначенийВрем.ЗагрузитьКолонку(ДанныеИзменяемойКолонки, Имя);
	ЗначениеВРеквизитФормы(ТаблицаЗначенийВрем, ИмяЭлементаТЗ());
	
	ТекущаяСтрока = НастройкиТаблицыЗначений.НайтиПоИдентификатору(Элементы.НастройкиТаблицыЗначений.ТекущаяСтрока);
	ИндексСтроки = НастройкиТаблицыЗначений.Индекс(ТекущаяСтрока);
	ВсегоСтрок = НастройкиТаблицыЗначений.Количество();
	
	Если ИндексСтроки < (ВсегоСтрок - 1) Тогда 
		НастройкаСоСледующейКолонкой = НастройкиТаблицыЗначений.Получить(ИндексСтроки + 1);
		Элементы.Переместить(Элементы[ИмяЭлемента(Имя)], Элементы[ИмяЭлементаТЗ()], Элементы[ИмяЭлемента(НастройкаСоСледующейКолонкой.Имя)]);
	КонецЕсли;
	
КонецПроцедуры	

// Формирует имя добавляемой колонки.
// Оно не должно совпадать с именем реквизита формы 
// и с именем колонки.
//
// Параметры:
//	Имя - передаваемое имя.
//
&НаКлиенте
Функция СформироватьИмяКолонки(знач ИмяКолонки, ИДТекСтроки)
	НТЗ = НастройкиТаблицыЗначений;
	Флаг = Истина;
	Индекс = 0;
	
	ИмяКолонки = СокрЛП(ИмяКолонки);
	
	Пока Флаг Цикл
		Имя = ИмяКолонки + Строка(Формат(Индекс, "ЧН=-"));
		// имя = СтрЗаменить(Имя, "-", "");
		Имя = ПреобразоватьВПравильноеНазваниеНаСервере(СтрЗаменить(Имя, "-", ""));
		
		// Если нет строки с таким именем.
		Фильтр = Новый Структура("НаименованиеКолонки", Имя);
		ОтфильтрованныеСтроки = НТЗ.НайтиСтроки(Фильтр);
		Если ОтфильтрованныеСтроки.Количество() = 0 Тогда
			Флаг = Ложь;
		Иначе
			Если ОтфильтрованныеСтроки.Получить(0).ПолучитьИдентификатор() <> ИДТекСтроки Тогда
				Флаг = Истина;
			Иначе
				Флаг = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		// Если нет колонки с таким именем.
		Колонки = Элементы.ТаблицаЗначенийПараметр.ПодчиненныеЭлементы;
		КолКолонок = Колонки.Количество();
		Для Индекс = 0 По КолКолонок - 1 Цикл
			Если Колонки.Получить(Индекс).Имя = Имя Тогда
				Флаг = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Результат = ?(Флаг, "", Имя);
		
		Индекс = Индекс + 1;
	КонецЦикла; 
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ИнициализацияКолонкиВТЗКлиент(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки)
	СообщениеСистемы = "";
	ИнициализацияКолонкиВТЗСервер(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки, СообщениеСистемы);
	Если НЕ ПустаяСтрока(СообщениеСистемы) Тогда
		ПоказатьСообщениеПользователю(СообщениеСистемы, "Объект");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКолонкиВТЗСервер(СтароеИмяКолонки, НовоеИмяКолонки, ТипКолонки, Сообщение = "");
	
	//ИмяУдаляемогоРеквизита = ИмяРодителя + "." + СтароеИмяКолонки;
	//
	//// Заполнение массива удаляемыми реквизитами.
	//МассивУдаляемыхРеквизитов = Новый Массив;
	//РекРодителя		= ПолучитьРеквизиты(ИмяРодителя);
	//Для каждого ТекРек Из РекРодителя Цикл
	//	Если ТекРек.Имя = СтароеИмяКолонки Тогда 
	//		МассивУдаляемыхРеквизитов.Добавить(ИмяУдаляемогоРеквизита);
	//	КонецЕсли;	
	//КонецЦикла;	
	//
	//// Выгрузка значений в таблицу значений.
	//Если Не ПустаяСтрока(СтароеИмяКолонки) Тогда
	//	ТЗЗначений = ТаблицаЗначенийПараметр.Выгрузить(, СтароеИмяКолонки);
	//Иначе	
	//	ТЗЗначений = Неопределено;
	//КонецЕсли;	
	//
	//// Добавление нового реквизита в объект.
	//ДобавляемыеРеквизиты = Новый Массив;
	//
	//НовыйРеквизит 	= Новый РеквизитФормы(НовоеИмяКолонки, ТипКолонки, ИмяРодителя, НовоеИмяКолонки, Ложь);
	//ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	//// изменитьРеквизиты(ДобавляемыеРеквизиты, МассивУдаляемыхРеквизитов);
	//ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
	//ИзменитьРеквизиты(ДобавляемыеРеквизиты, );
	//
	//// Поиск колонки в "ТаблицаЗначенийПараметр" с условием ПутьКДанным=ПутьКНовомуРеквизиту.
	//ИмяДобавляемогоРеквизита = ИмяРодителя + "." + НовоеИмяКолонки;
	//НомерКолонки = ПоискКолонокВТЗСЗаданнымПутемКДанным(ИмяДобавляемогоРеквизита);
	//Если ТЗЗначений <> Неопределено Тогда 
	//	Если НомерКолонки <> Неопределено Тогда 
	//		ИмяПервойКолонки = ТЗЗначений.Колонки.Получить(0).Имя;
	//		Индекс = 0;
	//		Для Каждого Стр Из ТЗЗначений Цикл 
	//			ТаблицаЗначенийПараметр.Получить(Индекс)[НовоеИмяКолонки] = Стр[ИмяПервойКолонки];
	//			Индекс = Индекс + 1;
	//		КонецЦикла;
	//	КонецЕсли;
	//Иначе
	//	НоваяКолонкаТаблицы = Элементы.Добавить(НовоеИмяКолонки, Тип("ПолеФормы"), Элементы.ТаблицаЗначенийПараметр);
	//	НоваяКолонкаТаблицы.ПутьКДанным = ИмяДобавляемогоРеквизита;
	//	НоваяКолонкаТаблицы.Вид			= ВидПоляФормы.ПолеВвода;
	//КонецЕсли;	
	
КонецПроцедуры

// Изменяет имя реквизита и колонки по идентификатору строки.
//
// Параметры:
//	ИДСтроки - идентификатор строки таблицы значений настроек.
//	Имя - новое передаваемое имя для реквизита и колонки.
//
&НаСервере
Процедура ИзменитьИмяРеквизитаИКолонкиСервер(СтароеИмя, НовоеИмя, ТипКолонки)
	//// НачатьТранзакцию();
	//
	//ИмяУдаляемогоРеквизита = ИмяРодителя + "." + СтароеИмя;
	//
	//// Заполнение массива удаляемыми реквизитами.
	//МассивУдаляемыхРеквизитов = Новый Массив;
	//РекРодителя		= ПолучитьРеквизиты(ИмяРодителя);
	//Для каждого ТекРек Из РекРодителя Цикл
	//	Если ТекРек.Имя = СтароеИмя Тогда 
	//		МассивУдаляемыхРеквизитов.Добавить(ИмяУдаляемогоРеквизита);
	//	КонецЕсли;	
	//КонецЦикла;	
	//
	//// Выгрузка значений в таблицу значений.
	//ТЗЗначений = ТаблицаЗначенийПараметр.Выгрузить(, СтароеИмя);
	//
	//// Добавление нового реквизита в объект.
	//ДобавляемыеРеквизиты = Новый Массив;
	//
	//НовыйРеквизит 	= Новый РеквизитФормы(НовоеИмя, ТипКолонки, ИмяРодителя, НовоеИмя, Ложь);
	//ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	//// изменитьРеквизиты(ДобавляемыеРеквизиты, МассивУдаляемыхРеквизитов);
	//ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
	//ИзменитьРеквизиты(ДобавляемыеРеквизиты, );
	//
	//// Поиск колонки в "ТаблицаЗначенийПараметр" с условием ПутьКДанным = ПутьКНовомуРеквизиту.
	//ИмяДобавляемогоРеквизита = ИмяРодителя + "." + НовоеИмя;
	//НомерКолонки = ПоискКолонокВТЗСЗаданнымПутемКДанным(ИмяДобавляемогоРеквизита);
	//Если НомерКолонки <> Неопределено Тогда 
	//	ИмяПервойКолонки = ТЗЗначений.Колонки.Получить(0).Имя;
	//	Индекс = 0;
	//	Для Каждого СтарСтр Из ТЗЗначений Цикл 
	//		ТаблицаЗначенийПараметр.Получить(Индекс)[НовоеИмя] = СтарСтр[ИмяПервойКолонки];
	//		Индекс = Индекс + 1;
	//	КонецЦикла;	
	//// #рефакторинг	
	//// иначе
	////	НоваяКолонкаТаблицы = Элементы.Добавить(ИмяРодителя + НовоеИмя, Тип("ПолеФормы"), Элементы.ТаблицаЗначенийПараметр);
	////	НоваяКолонкаТаблицы.ПутьКДанным = ИмяДобавляемогоРеквизита;
	////	НоваяКолонкаТаблицы.Вид			= ВидПоляФормы.ПолеВвода;
	////	
	////	НомерКолонки = ПоискКолонокВТЗСЗаданнымПутемКДанным(ИмяУдаляемогоРеквизита);
	////	ИмяПервойКолонки = ТЗЗначений.Колонки.Получить(0).Имя;
	////	Индекс = 0;
	////	Для Каждого СтарСтр Из ТЗЗначений Цикл 
	////		ТаблицаЗначенийПараметр.Получить(Индекс)[НовоеИмя] = СтарСтр[ИмяПервойКолонки];
	////		Индекс = Индекс + 1;
	////	КонецЦикла;	
	////	
	//КонецЕсли;
	//
	//// зафиксироватьТранзакцию();
КонецПроцедуры // ИзменитьИмяРеквизитаИКолонкиСервер()

// Возвращает номер колонки с заданным путем.
//
// Параметры:
//	ПутьКДанным - заданный путь.
//
//	Возвращаемое значение: номер колонки или Неопределено.
//
&НаСервере
Функция ПоискКолонокВТЗСЗаданнымПутемКДанным(ПутьКДанным)
	Колонки 			= Элементы.ТаблицаЗначенийПараметр.ПодчиненныеЭлементы;
	КоличествоКолонок 	= Колонки.Количество();
	Флаг				= Ложь;
	Для Индекс = 0 По КоличествоКолонок - 1 Цикл
		ТекКолонка = Колонки.Получить(Индекс);
		Если ТекКолонка.ПутьКДанным = ПутьКДанным Тогда
			Возврат Индекс;
		КонецЕсли;	
	КонецЦикла;	
    Возврат Неопределено;
КонецФункции

Процедура ПоказатьСообщениеПользователю(ТекстСообщения, ПутьКДанным)
	
	//Сообщение = Новый СообщениеПользователю();
	//Сообщение.Текст = НСтр("ru = '" + СтрЗаменить(ТекстСообщения, "'", "''") + "'");
	//Сообщение.Сообщить();
	
	//ОчиститьСообщения();
	Сообщение = Новый СообщениеПользователю(); 
    Сообщение.Текст = ТекстСообщения;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.УстановитьДанные(Объект); 
    Сообщение.Сообщить(); 	
КонецПроцедуры	

&НаКлиенте
Функция УбратьСимволыИзТекста(знач Текст)
	Результат = "";
	
	ДлинаТекста = СтрДлина(Текст);
	
	Если ДлинаТекста = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Индекс = 0 По ДлинаТекста - 1 Цикл
		СимволТекста = Лев(Текст, 1);
		Если Не ЭтоСимвол(СимволТекста) Тогда
			Результат = Результат + СимволТекста;
		КонецЕсли;
		Текст = Сред(Текст, 2);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ЭтоСимвол(Символ)
	// Символы между 1040 и 1103 - Русские буквы.
	// Символы между 48 и 57 - Цифры.
	// Символы между 65 и 122 - Английские буквы.
	
	Код = КодСимвола(Символ); 
	Если (Код >= 1040 И Код <= 1103) Или (Код >= 48 И Код <= 57) Или (Код >= 65 И Код <= 122) Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ИмяТипаПоЗначению(Значение)
	
	Возврат Значение.Метаданные().Имя;
	
КонецФункции	

Функция РезультатВСтрокуВнутр()
	
	Возврат ЗначениеВСтрокуВнутр(РеквизитФормыВЗначение("ТаблицаЗначенийПараметр"))

КонецФункции // РезультатВСтрокуВнутр()()

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция МетодыПоискаВСтроке() Экспорт
	Возврат Новый Структура("Точно, Вначале, Вконце, Посередине", "Точно", "Вначале", "Вконце", "Посередине");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяЭлементаТЗ()
	Возврат "ТаблицаЗначенийПараметр";
КонецФункции

&НаСервереБезКонтекста
Функция ОбъектОбработки()
	Возврат Новый ("ВнешняяОбработкаОбъект.КонсольЗапросов");
КонецФункции

#Область УниверсальныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТипЗначенияСтрока(ДлинаСтроки = 500)
	КвалификаторыСтроки = Новый КвалификаторыСтроки(500);
	Возврат Новый ОписаниеТипов("Строка", ,КвалификаторыСтроки);
КонецФункции


#Область РаботаСJSON

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеВСтроку(ПроизвольноеЗначение, ИмяФайла = "")
	
	ЗаписьJSON = Новый ЗаписьJSON;
	Если ЗначениеЗаполнено(ИмяФайла) Тогда 
		ЗаписьJSON.ОткрытьФайл(ИмяФайла);
	Иначе
		ЗаписьJSON.УстановитьСтроку();
	КонецЕсли;
	 
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, ПроизвольноеЗначение, НазначениеТипаXML.Явное);
	
	СериализованнаяСтрока = ЗаписьJSON.Закрыть();
	
	Возврат СериализованнаяСтрока
	
КонецФункции // ЗначениеВСтроку()

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеИзСтроки(СтрокаJSON, ИмяФайла = "")
	
	Если ПустаяСтрока(СтрокаJSON) Тогда 
		Возврат "";
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	Если ЗначениеЗаполнено(ИмяФайла) Тогда 
		ЧтениеJSON.ОткрытьФайл(ИмяФайла);
	Иначе
		ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	КонецЕсли;

	Ошибка = "";
	Попытка
		ПроизвольноеЗначение = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON);	
	Исключение
		Ошибка = ОписаниеОшибки();
	КонецПопытки;

	Если ПустаяСтрока(Ошибка) Тогда 
		ЧтениеJSON.Закрыть();
		Возврат ПроизвольноеЗначение
	КонецЕсли;
	
	#Если Сервер Тогда
	ПроизвольноеЗначение = ЗначениеИзСтрокиВнутр(СтрокаJSON);
	
	Возврат ПроизвольноеЗначение;
	#Иначе
	ВызватьИсключение Ошибка;
	#КонецЕсли
		
КонецФункции // ЗначениеИзСтроки()

#КонецОбласти

#КонецОбласти

#КонецОбласти

///////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ИмяКолонкиПоУмолчанию 	= "Колонка";


