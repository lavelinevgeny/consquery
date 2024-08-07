﻿///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мТекущаяСтрока; // текущая(прошлая) строка списка вариантов кода.

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// ОбластьЗавершенияАсинхронныхВызовов

&НаКлиенте
Процедура ПоказатьПредупреждениеЗавершение(ДополнительныеПараметры) Экспорт
КонецПроцедуры // ПоказатьПредупреждениеЗавершение()

// Прочие процедуры и функции

&НаКлиенте
Процедура ЗаполнитьНовуюСтроку(НоваяСтрока)
	НоваяСтрока.Имя = "Вариант №" + ИсполняемыйКодСписок.Количество();
	НоваяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
КонецПроцедуры // ЗаполнитьНовуюСтроку()

&НаКлиенте
Процедура ПодставитьПредустановленныйКод(ВидПредустановленногоКода)
	
	Если ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока <> Неопределено тогда
		Если ВидПредустановленногоКода = гТипыПредустановленногоКода().ВставитьЦикл Тогда 
			ТекстДляПодстановки = гПолучитьПредустановленныйКодВставитьЦикл(ВладелецФормы.РезультатЗапроса().Колонки);
		ИначеЕсли ВидПредустановленногоКода = гТипыПредустановленногоКода().РедактироватьРегистрСведений Тогда 			
			лЗначениеПоУмолчанию = Неопределено;
			лСписокОбъектовМетаданных  = гПолучитьСписокОбъектовМетаданныхИзТекста(ВладелецФормы.гТекстЗапроса(), "РегистрыСведений", лЗначениеПоУмолчанию, гСтруктураКЭШ);
			лВыбранныйОбъектМетаданных = лСписокОбъектовМетаданных.ВыбратьЭлемент("Выберите регистр для редактирования", лСписокОбъектовМетаданных.НайтиПоЗначению(лЗначениеПоУмолчанию));
			Если лВыбранныйОбъектМетаданных <> Неопределено Тогда 
				ТекстДляПодстановки = гПолучитьПредустановленныйКодРедактироватьРегистрСведений(лВыбранныйОбъектМетаданных.Значение, ВладелецФормы.гТекстЗапроса());
			КонецЕсли;
		ИначеЕсли ВидПредустановленногоКода = гТипыПредустановленногоКода().РедактироватьДокументы Тогда 			
			лЗначениеПоУмолчанию = Неопределено;
			лСписокОбъектовМетаданных  = гПолучитьСписокОбъектовМетаданныхИзТекста(ВладелецФормы.гТекстЗапроса(), "Документы", лЗначениеПоУмолчанию, гСтруктураКЭШ);
			лВыбранныйОбъектМетаданных = лСписокОбъектовМетаданных.ВыбратьЭлемент("Выберите документ для редактирования", лСписокОбъектовМетаданных.НайтиПоЗначению(лЗначениеПоУмолчанию));
			Если лВыбранныйОбъектМетаданных <> Неопределено Тогда 
				ТекстДляПодстановки = гПолучитьПредустановленныйКодРедактироватьДокумент(лВыбранныйОбъектМетаданных.Значение, ВладелецФормы.гТекстЗапроса());
			КонецЕсли;
		ИначеЕсли ВидПредустановленногоКода = гТипыПредустановленногоКода().РедактироватьСправочники Тогда 			
			лЗначениеПоУмолчанию = Неопределено;
			лСписокОбъектовМетаданных  = гПолучитьСписокОбъектовМетаданныхИзТекста(ВладелецФормы.гТекстЗапроса(), "Справочники", лЗначениеПоУмолчанию, гСтруктураКЭШ);
			лВыбранныйОбъектМетаданных = лСписокОбъектовМетаданных.ВыбратьЭлемент("Выберите справочник для редактирования", лСписокОбъектовМетаданных.НайтиПоЗначению(лЗначениеПоУмолчанию));
			Если лВыбранныйОбъектМетаданных <> Неопределено Тогда 
				ТекстДляПодстановки = гПолучитьПредустановленныйКодРедактироватьСправочник(лВыбранныйОбъектМетаданных.Значение, ВладелецФормы.гТекстЗапроса());
			КонецЕсли;
		Иначе
			Возврат
		КонецЕсли;
		ПодставитьТекстВПолеНаФорме(ТекстДляПодстановки);
	Иначе
		ПоказатьПредупреждение(, "Выберите или введите новый вариант для подстановки кода.")
	КонецЕсли;

КонецПроцедуры // ПодставитьПредустановленныйКод()
 
// Процедура выводит информацию по позиции курсора в строке с произвольным кодом
//
// Параметры
//  Нет
//
&НаКлиенте
Процедура ВывестиПозициюКурсора()
	
	СтрокаНач  = 1;
	КолонкаНач = 1;              
	СтрокаКон  = 1;
	КолонкаКон = 1;
	ЭлементыФормы.КодДляВыполнения.ПолучитьГраницыВыделения(СтрокаНач, КолонкаНач, СтрокаКон, КолонкаКон);
	
	НадписьПозицияКурсора = "Строка: " + СтрокаНач + "	Кол: " + КолонкаНач;

КонецПроцедуры // ВывестиПозициюКурсора()

Процедура УстановитьДоступность()
	ЭлементыФормы.КодДляВыполнения.Доступность = (ИсполняемыйКодСписок.Количество() > 0);
КонецПроцедуры

//#рефакторинг реализовать все подстановки через процедуруа ПодставитьПредустановленныйКод
Процедура ПодставитьТекстВПолеНаФорме(ТекстДляПодстановки)
	
	ПолеСТекстом = ЭтаФорма.Элементыформы.КодДляВыполнения;
	Если ПолеСТекстом.КоличествоСтрок() = 0 тогда
		ПолеСТекстом.УстановитьТекст(ТекстДляподстановки);
	Иначе
		СтруктураКоординат = гПолучитьГраницыВыделенияПоляФормы(ПолеСТекстом);
		ТекущаяСтрока = ПолеСТекстом.ПолучитьСтроку(СтруктураКоординат.СтрокаНач);
		
		Если СтрДлина(ТекущаяСтрока) < СтруктураКоординат.КолонкаКон Тогда
			СтруктураКоординат.КолонкаНач = СтрДлина(ТекущаяСтрока) + 1;
			СтруктураКоординат.КолонкаКон = СтруктураКоординат.КолонкаНач;
		КонецЕсли;
		
		СтруктураТекста = гПолучитьСтруктуруТекстаДоИПослеКурсора(ПолеСТекстом, СтруктураКоординат);
		ПолеСТекстом.УстановитьТекст(СтруктураТекста.ТекстДо + ТекстДляподстановки + СтруктураТекста.ТекстПосле);
	КонецЕсли;
	
	Модифицированность = Истина;		
								
КонецПроцедуры // ПодставитьТекстВПолеНаФорме()

Функция СохранитьтекстКодаТекущейСтроки(ЗапрашиватьСохранение = Ложь)
	Результат = 1;
	Если Модифицированность и ЗапрашиватьСохранение тогда
	// сохранить, не сохранить , отмена	
		ФормаВопроса=ПолучитьФорму("ФормаСложныйВопрос");
		ФормаВопроса.Параметры.Добавить("Сохранить изменения");
		ФормаВопроса.Параметры.Добавить("Кнопка Сохранить","Сохранить");
		ФормаВопроса.Параметры.Добавить("Кнопка НеСохранить","Не сохранить",Истина);
		ФормаВопроса.Параметры.Добавить("Кнопка Отмена","Отмена",Истина);
		Ответ = ФормаВопроса.ОткрытьМодально(30);
		Если Найти(Ответ,"Отмена")>0 тогда
			Результат = 0;
		ИначеЕсли Найти(Ответ,"Не cохранить")>0 тогда
			Результат = 2;                   
		КонецЕсли;
	КонецЕсли;
	
	Если Результат = 1 тогда
		Если мТекущаяСтрока <> Неопределено тогда
			мТекущаяСтрока.Текст = ЭлементыФормы.КодДляВыполнения.ПолучитьТекст();
		КонецЕсли;
	КонецЕсли;

	Возврат Результат
КонецФункции

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	мТекущаяСтрока = Неопределено;
	лПутькКартинке = гЗначениеИзСеансовыхДанных("ПутькКартинкам", гСеансовыеДанные);
	лКореньМеню    = гЗаполнитьМенюПоДереву(ЭлементыФормы.КоманднаяПанельОсновная, Неопределено, гПолучитьМеню("ПредустановленныйКод", Ложь, Ложь, лПутькКартинке));
	
	Если лКореньМеню <> Неопределено Тогда 
		лКореньМеню.Отображение = ОтображениеКнопкиКоманднойПанели.НадписьКартинка;
	КонецЕсли;
	
КонецПроцедуры // ПередОткрытием()

Процедура ПриОткрытии()
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Если ИсполняемыйКодСписок.Количество() = 0 тогда
		ЗаполнитьНовуюСтроку(ИсполняемыйКодСписок.Добавить())
	КонецЕсли;
	
	Если ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока = Неопределено тогда
		ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока = ИсполняемыйКодСписок[0];
	КонецЕсли;
	
	мТекущаяСтрока = ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока;
	
	УстановитьДоступность();
	
	ПодключитьОбработчикОжидания("ВывестиПозициюКурсора", 1);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказж, СтандартнаяОбработка)
	СохранитьтекстКодаТекущейСтроки();
	ВладелецФормы.Модифицированность = ?(ВладелецФормы.Модифицированность, 
		ВладелецФормы.Модифицированность, Модифицированность);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура ПредустановленныйКодВыбратьЗначениеПараметра(Кнопка)
	
	лСтрокаСПараметром = ВладелецФормы.мФормаПараметров.ПараметрыСписок.ВыбратьСтроку();
	
	Если лСтрокаСПараметром <> Неопределено Тогда 
		
		ПодставитьТекстВПолеНаФорме(гПодставитьПараметрыВСтроку("Параметр_%1 = мФормаПараметров.гПолучитьПараметрПоИмени(""%1"");", лСтрокаСПараметром.Имя));
		
	КонецЕсли;		
	
КонецПроцедуры // ПредустановленныйКодВыбратьЗначениеПараметра()

// #рефакторинг удалить функционал с 01.01.2021г
Процедура ПредустановленныйКодДобавитьРезультатЗапросаВПараметр(Кнопка)
	ПоказатьПредупреждение(Новый ОписаниеОповещения("ПоказатьПредупреждениеЗавершение", ЭтаФорма), "Функционал устарел. Используйте меню действий с результатом запросов.", 10, "Информация");
	
	Возврат;
	
	Если ВладелецФормы.СпособВыгрузкиДерево() Тогда 
		ПоказатьПредупреждение(, "Данный функционал работает только для способа выгрузки ""Список"" ", 10); // #рефакторинг подставить первый параметр в ПоказатьПредупреждение для совместимости версий
		Возврат;
	КонецЕсли;
	
	Если ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока <> Неопределено тогда

		лИмяПараметра = "РезультатЗапроса";
		
		Если ВвестиСтроку(лИмяПараметра, "Введите имя параметра для хранения таблицы значений") Тогда 
			
			лАлгоритм = 
				"// Добавление данных из таблицы с результатом запроса в глобальную структуру 
				|// для возможности использовать в запросах в виде временной таблицы.
				|// (в значении параметра необходимо указать имя ключа глобальной структуры, 
				|// в которой хранится таблица значений для временной таблицы формируемого запроса)
				|
				|// Текст запроса после добавления в глобальную структуру:
				|// 	'Выбрать * Поместить вт%ИмяПараметра% из &%ИмяПараметра% КАК Выборка'
				|
				|Если %ИмяТаблицыСРезультатом%.Колонки.Количество() = 0 Тогда
				|	Сообщить(""Результат запроса пуст."", СтатусСообщения.Важное);
				|Иначе
				|
				|	лИмяПараметра = ""%ИмяПараметра%"";				
				|
				|	лПараметрУжеДобавлен = гГлобальныеПеременные.Свойство(лИмяПараметра);
				|
				|	Если лПараметрУжеДобавлен Тогда
				|		Сообщить(""В структуре 'гГлобальныеПеременные' уже существует параметр с ключем '"" + лИмяПараметра + ""'."", СтатусСообщения.Важное);
				| 	Иначе
				|		// добавляем в глобальную структуру результат запроса
				|		гГлобальныеПеременные.Вставить(лИмяПараметра, %ИмяТаблицыСРезультатом%.Скопировать());
				|
				|		// добавляем в список параметров параметр с результатом запроса, если его еще нет
				|		лПараметрыЗапроса = мФормаПараметров.ПараметрыСписок;
				|
				|		лСтрокаСПараметром = гПолучитьПараметр(лИмяПараметра, текПараметры);
				|
				|		Если лСтрокаСПараметром = Неопределено Тогда
				|			лСтрокаСПараметром          = лПараметрыЗапроса.Добавить();
				|			лСтрокаСПараметром.Тип      = гТипыЗначенийПараметров().ТаблицаЗначений;
				|			лСтрокаСПараметром.Имя      = лИмяПараметра;
				|			лСтрокаСПараметром.Значение = лИмяПараметра;
				|		КонецЕсли;
				|
				|	КонецЕсли;
				|";
			
			лАлгоритм = СтрЗаменить(лАлгоритм, "%ИмяТаблицыСРезультатом%", гСвойстваРеквизитаРезультатЗапроса().ИмяРеквизита);
			лАлгоритм = СтрЗаменить(лАлгоритм, "%ИмяПараметра%"          , лИмяПараметра);
			
			ПодставитьТекстВПолеНаФорме(лАлгоритм);
		КонецЕсли;
	Иначе                        
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите существующий или введите новый вариант для подстановки кода.'"));
	КонецЕсли;
	
КонецПроцедуры // ПредустановленныйКодДобавитьРезультатЗапросаВПараметр()

Процедура ПредустановленныйКодПодключитьБазу(Кнопка)
	
	Если ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока <> Неопределено тогда
		
		// Выбираем базу, которую необходимо подключить
		ТекПараметрИБ  = ВладелецФормы.мФормаПараметрыИБ.ТаблицаПараметров.ВыбратьСтроку();
		Если ТекПараметрИБ <> Неопределено тогда
			
			ТекстДляПодстановки = "ТекПараметрИБ = мФормаПараметрыИБ.ТаблицаПараметров[0];
			|СтруктураПараметров = Новый Структура();
			|СтруктураПараметров.Вставить(""Установить""       , Истина);
			|СтруктураПараметров.Вставить(""Коннектор""        , ""V81.COMConnector"");
			|СтруктураПараметров.Вставить(""КаталогБазы""      , ""%КаталогБазы%"");
			|СтруктураПараметров.Вставить(""SQL_Сервер""       , ""%SQL_Сервер%"");
			|СтруктураПараметров.Вставить(""SQL_БазаДанных""   , ""%SQL_БазаДанных%"");
			|СтруктураПараметров.Вставить(""ТипБазы""          , ""%ФайловаяБаза%"");
			|СтруктураПараметров.Вставить(""ИмяПользователя""  , ""%ИмяПользователя%"");
			|СтруктураПараметров.Вставить(""Пароль""           , ""%Пароль%"");
			|СтруктураПараметров.Вставить(""ВыводитьСообщение"", Истина);
			|
			|V8COM = КоннекторКВнешнейБазе(СтруктураПараметров);	
			|Если V8COM <> Неопределено тогда		
			|	// ошибка подключения
			|Иначе
			|	// удачно подключились
			|КонецЕсли;";
			
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%КаталогБазы%"    , ТекПараметрИБ.КаталогБазы);
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%SQL_Сервер%"     , ТекПараметрИБ.SQL_Сервер);
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%SQL_БазаДанных%" , ТекПараметрИБ.SQL_БазаДанных);
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%ФайловаяБаза%"   , ?(ТекПараметрИБ.ФайловаяБаза, "ИСТИНА", "ЛОЖЬ"));
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%ИмяПользователя%", ТекПараметрИБ.ИмяПользователя);
			ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%Пароль%"         , ТекПараметрИБ.Пароль);
			
			ПодставитьТекстВПолеНаФорме(ТекстДляПодстановки);
			
			Модифицированность = Истина;
			
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, "Выберите или введите новый вариант для подстановки кода.")
	КонецЕсли;
	
КонецПроцедуры // ПредустановленныйКодПодключитьБазу()

Процедура ПредустановленныйКодВставитьЦикл(Кнопка)
	ПодставитьПредустановленныйКод(гТипыПредустановленногоКода().ВставитьЦикл);
КонецПроцедуры

Процедура ПредустановленныйКодПеренумероватьСправочник(Кнопка)
	
	Если ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока <> Неопределено тогда

		ТекстДляПодстановки = "лПозиция = 0;
		|лДлинаКодаСправочника = 9;
		|Для Каждого СтрокаЗапроса из %ИмяРеквизитаРезультатаЗапроса% Цикл
		|
		|	ОбработкаПрерыванияПользователя();
		|
		|	лПозиция = лПозиция + 1;
		|	Состояние(""Выполнено "" + Окр(лПозиция / %ИмяРеквизитаРезультатаЗапроса%.Количество() * 100) + ""%"");
		|
		|	НовыйНомер = Формат(лПозиция, ""ЧЦ="" + лДлинаКодаСправочника + ""; ЧВН=; ЧГ=0"");
		|
		|	СпрОбъект = СтрокаЗапроса.Ссылка.ПолучитьОбъект();
		|	СпрОбъект.Код = НовыйНомер;
		|	СпрОбъект.ОбменДанными.Загрузка = Истина;
		|	СпрОбъект.Записать();
		|	
		|КонецЦикла;
		|
		|Сообщить(""Обработка закончена."", СтатусСообщения.Важное);";
		
		ТекстДляПодстановки = СтрЗаменить(ТекстДляПодстановки, "%ИмяРеквизитаРезультатаЗапроса%", гСвойстваРеквизитаРезультатЗапроса().ИмяРеквизита);
		ПодставитьТекстВПолеНаФорме(ТекстДляПодстановки);
		
	Иначе
		ПоказатьПредупреждение(, "Выберите или введите новый вариант для подстановки кода.")
	КонецЕсли;

КонецПроцедуры // ПредустановленныйКодПеренумероватьСправочник()

Процедура ПредустановленныйКодРедактироватьРегистрСведений(Кнопка)
	ПодставитьПредустановленныйКод(гТипыПредустановленногоКода().РедактироватьРегистрСведений);
КонецПроцедуры // ПредустановленныйКодРедактироватьРегистрСведений

Процедура ПредустановленныйКодРедактироватьДокументы(Кнопка)
	ПодставитьПредустановленныйКод(гТипыПредустановленногоКода().РедактироватьДокументы);
КонецПроцедуры

Процедура ПредустановленныйКодРедактироватьСправочники(Кнопка)
	ПодставитьПредустановленныйКод(гТипыПредустановленногоКода().РедактироватьСправочники);
КонецПроцедуры

Процедура ВыгрузитьКодВОблако(Кнопка)
	лИдентификаторСессии = гВосстановитьИдентификаторСессииConsqueryCloud();
	Если Не ЗначениеЗаполнено(лИдентификаторСессии) Тогда 
		Оповестить("НеобходимоПереподключиться", , ЭтаФорма);
		Возврат;
	Иначе
		
		лФормаДиалога = ПолучитьФорму("ФормаДиалогВыбораИсточникаДанныхИзОблака", ЭтаФорма);
		лФормаДиалога.Режим               = гОперацииСЗапросами().СохранитьКАК;
		лФормаДиалога.Тип                 = гТипыИсточниковДанных().Код;
		лФормаДиалога.ИмяЭлементаИзОблака = "Запросы от " + Формат(ТекущаяДата(), "ДФ='dd.MM.yyyy ЧЧ_ММ_сс'");
		Длг = лФормаДиалога.ОткрытьМодально();
		
		Если Длг = Неопределено Или Не Длг.Выбран Тогда
			Возврат;
		КонецЕсли;
		
		лМассивСтрокКода = Новый Массив;
		лМассивСтрокКода.Добавить(Новый Структура("ИдентификаторЗапроса, ИдентификаторСтроки, Имя, Текст", ));
		
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.ПроверятьСтруктуру = Ложь;
		
		Данные = Новый Структура();
		Данные.Вставить("codes", лМассивСтрокКода);
		ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(,,,,,,Истина));
		ЗаписатьJSON(ЗаписьJSON, Данные, Новый НастройкиСериализацииJSON);
		
		лИдентификаторСессии = гВосстановитьИдентификаторСессииConsqueryCloud();
		лДанные = ЗаписьJSON.Закрыть();
		
		лРезультат = гСохранитьКодВОблаке(лИдентификаторСессии, Длг.ИдПакета, Длг.ИдЗапроса, Длг.ИдКода, Длг.Имя, ЭлементыФормы.КодДляВыполнения.ПолучитьТекст());
		
		Если Не лРезультат.Статус = "OK" Тогда 
			Ошибка = Истина;
			Сообщить("Ошибка сохранения в облаке: " + лРезультат.ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если Вопрос("Вы уверены? :)", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК тогда
		Закрыть(ЭлементыФормы.КодДляВыполнения.ПолучитьТекст());
	КонецЕсли;
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ <ИсполняемыйКодСписок>

Процедура ИсполняемыйКодСписокПередУдалением(Элемент, Отказ)
	мТекущаяСтрока = Неопределено;
КонецПроцедуры

Процедура ИсполняемыйКодСписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования Тогда
		мТекущаяСтрока = Неопределено;
	ИначеЕсли НоваяСтрока тогда
		УстановитьДоступность();
	КонецЕсли;
КонецПроцедуры

Процедура ИсполняемыйКодСписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока тогда
		ЗаполнитьНовуюСтроку(Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	Если Копирование тогда
		ЭлементыФормы.КодДляВыполнения.УстановитьТекст(мТекущаяСтрока.Текст);	
	КонецЕсли;
КонецПроцедуры

Процедура ИсполняемыйКодСписокПослеУдаления(Элемент)
	УстановитьДоступность();
КонецПроцедуры

Процедура ИсполняемыйКодСписокПриАктивизацииСтроки(Элемент)
	
	СохранитьтекстКодаТекущейСтроки();
	
	мТекущаяСтрока = ЭлементыФормы.ИсполняемыйКодСписок.ТекущаяСтрока;
	
	Если мТекущаяСтрока = Неопределено тогда
		ЭлементыФормы.КодДляВыполнения.Очистить();	
	Иначе
		ЭлементыФормы.КодДляВыполнения.УстановитьТекст(мТекущаяСтрока.Текст);	
	КонецЕсли;
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ