﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// #рефакторинг заменить вызов на гПреобразоватьВПравильноеНазвание
Функция кзгПреобразоватьВПравильноеНазвание(Знач ИсходноеНазвание)
	ДоступныеСимволы = "1234567890qwertyuiopasdfghjklzxcvbnmйцукенгшщзхъфывапролджэячсмитьбю";
	сч = 0;
	Пока сч<=СтрДлина(ИсходноеНазвание) Цикл
		сч = сч + 1;
		Если Найти(ДоступныеСимволы, Сред(НРег(ИсходноеНазвание), сч, 1))=0 тогда
			ИсходноеНазвание = СтрЗаменить(ИсходноеНазвание,Сред(ИсходноеНазвание, сч, 1), "");
			сч = сч - 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИсходноеНазвание
	
КонецФункции

// Возвращает таблицу параметров информационных баз по файлу *.v8i
// Автор: Лавелин Евгений, lavelin.ru
//
// Параметры
//  <ИмяФайлаСоСпискомБаз>  - <Строка> - <Файл типа *.v8i со списком информационных баз>
//
// Возвращаемое значение:
//   <ТаблицаЗначений>   - <Дерево со списком информационных баз>
//
Функция ПолучитьТаблицуПараметровИнформационныхБаз(ИмяФайлаСоСпискомБаз)

	ТаблицаПараметровИБ = Новый ТаблицаЗначений();
	ТаблицаПараметровИБ.Колонки.Добавить("ИмяБазы");
	ТаблицаПараметровИБ.Колонки.Добавить("Connect", Новый ОписаниеТипов("Строка"));
	ТаблицаПараметровИБ.Колонки.Добавить("OrderInList");
	ТаблицаПараметровИБ.Колонки.Добавить("Версия");
	ТаблицаПараметровИБ.Колонки.Добавить("SQL_Сервер");
	ТаблицаПараметровИБ.Колонки.Добавить("SQL_БазаДанных");
	ТаблицаПараметровИБ.Колонки.Добавить("КаталогБазы");
	ТаблицаПараметровИБ.Колонки.Добавить("ФайловаяБаза"); // истина = Файловая, Ложь = SQL

	Текст = Новый ЧтениеТекста(ИмяФайлаСоСпискомБаз, КодировкаТекста.UTF8);
	Стр = Текст.ПрочитатьСтроку();
	
	Пока Стр <> Неопределено Цикл
		
		Если Найти(Стр, "[") = 1 Тогда 
			НоваяСтрока = ТаблицаПараметровИБ.Добавить();
			НоваяСтрока.ИмяБазы = Сред(Стр, 2, СтрДлина(Стр) - 2);
		ИначеЕсли Найти(Стр, "Connect=")= 1 Тогда 
			текСтрокаПодключения = Сред(Стр, 9, СтрДлина(Стр) - 10);
			НоваяСтрока.Connect = текСтрокаПодключения;
			Позиция_File = Найти(текСтрокаПодключения, "File=");
			Если Позиция_File > 0 Тогда 
				НоваяСтрока.ФайловаяБаза = Истина;
				НоваяСтрока.КаталогБазы = Сред(текСтрокаПодключения, 7, СтрДлина(текСтрокаПодключения) - 6);
			Иначе
				текПоз = Найти(текСтрокаПодключения, "Srvr=") + 6;
				НоваяСтрока.SQL_Сервер = Сред(текСтрокаПодключения, текПоз, Найти(текСтрокаПодключения, ";") - текПоз - 1);
				текПоз = Найти(текСтрокаПодключения, "Ref=") + 5;
				НоваяСтрока.SQL_БазаДанных = Сред(текСтрокаПодключения, текПоз, СтрДлина(текСтрокаПодключения) - текПоз + 1);
				НоваяСтрока.ФайловаяБаза = Ложь;
			КонецЕсли;
		ИначеЕсли Найти(Стр, "OrderInList=") = 1 Тогда 
			НоваяСтрока.OrderInList = Сред(Стр, 13, СтрДлина(Стр) - 12);
		ИначеЕсли Найти(Стр, "Version=") = 1 Тогда 
			НоваяСтрока.Версия = Сред(Стр, 9, СтрДлина(Стр) - 7);
		КонецЕсли;

	    Стр = Текст.ПрочитатьСтроку();
		
	КонецЦикла;	
	
	// удаляем ветки из дерева в которых не определена строка подлкючения
	текМассивСтрокДляУдаления = ТаблицаПараметровИБ.НайтиСтроки(Новый Структура("Connect", ""));
	Для каждого ТекСтрока Из текМассивСтрокДляУдаления Цикл
		ТаблицаПараметровИБ.Удалить(ТекСтрока);
	КонецЦикла; 
	
	ТаблицаПараметровИБ.Сортировать("OrderInList");
	
	Возврат ТаблицаПараметровИБ
	
КонецФункции // ПолучитьТаблицуПараметровИнформационныхБаз()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанель2ЗагрузитьИзФайлаСоСписком(Кнопка)
	
	Если Не гИнициализацияVBScript() тогда
		Возврат;	
	КонецЕсли;
	
	Если ТаблицаПараметров.Количество()>0 тогда
		ФормаВопроса = ПолучитьФорму("ФормаСложныйВопрос");
		ФормаВопроса.Параметры.Добавить("Список баз не пустой. Загрузить список баз");
		ФормаВопроса.Параметры.Добавить("Кнопка Добавить","Добавить");
		ФормаВопроса.Параметры.Добавить("Кнопка Заменить","Очистить и загрузить",Истина);
		ФормаВопроса.Параметры.Добавить("Кнопка Отмена","Отмена");
		Ответ = ФормаВопроса.ОткрытьМодально(30);
		Если Найти(Ответ,"Отмена")>0 тогда
			Возврат;
		ИначеЕсли Найти(Ответ,"Заменить")>0 тогда
			ТаблицаПараметров.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);

	мПутьКФайлу = ВосстановитьЗначение("КонсольЗапросов_ОтЛавелина_ПутьКФайлуСоспискомБаз");
	Если Не ЗначениеЗаполнено(мПутьКФайлу) тогда
		WshShell = Новый COMОбъект("WScript.Shell");
		мПутьКФайлу = WshShell.ExpandEnvironmentStrings("%APPDATA%\1C\1CEStart");
	КонецЕсли;
	
	Длг.Каталог = мПутьКФайлу;
	Длг.Заголовок = "Выберите файл со списком баз";
	Длг.Фильтр = "Файлы веток (*.v8i)|*.v8i";
	Длг.Расширение = "v8i";
		
	Если Длг.Выбрать() Тогда
		СохранитьЗначение("КонсольЗапросов_ОтЛавелина_ПутьКФайлуСоспискомБаз",Длг.Каталог);
	Иначе
		Возврат;
	КонецЕсли;
	
	текДеревоПараметровПодключения = ПолучитьТаблицуПараметровИнформационныхБаз(Длг.ПолноеИмяФайла);
	
	Для каждого ТекСтрока Из текДеревоПараметровПодключения Цикл
	
		ИмяБазы = кзгПреобразоватьВПравильноеНазвание(ТекСтрока.ИмяБазы);
		Если ТаблицаПараметров.НайтиСтроки(Новый Структура("ИмяБазы",ИмяБазы)).Количество()>0 тогда
			Сообщить("Уже существует строка с базой: " + ИмяБазы);
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаПараметров.Добавить();
		
		НоваяСтрока.ИмяБазы = ИмяБазы;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока,, "ИмяБазы");
		НоваяСтрока.Использовать = Истина;
		
	КонецЦикла; 
	
	//Текстсосписком = Новый ТекстовыйДокумент;
	//Текстсосписком.Прочитать(Длг.ПолноеИмяФайла);
	//
	//RegExp.Pattern="\[.*\n.*";
	// массив = RegExp.Execute(Текстсосписком.ПолучитьТекст());
	//
	// для каждого ЭлементМассива Из Массив Цикл
	//	
	//	RegExp.Pattern="\[.*";
	//	Массив1 = RegExp.Execute(ЭлементМассива.Value);
	//	ИмяБазы = кзгПреобразоватьВПравильноеНазвание(Сред(Массив1.Item(0).Value, 2, СтрДлина(Массив1.Item(0).Value)-2));
	//	Если ТаблицаПараметров.НайтиСтроки(Новый Структура("ИмяБазы",ИмяБазы)).Количество()>0 тогда
	//		Сообщить("Уже существует строка с базой: " + ИмяБазы);
	//		Продолжить;
	//	КонецЕсли;
	//	
	//	НоваяСтрока = ТаблицаПараметров.Добавить();
	//	
	//	НоваяСтрока.ИмяБазы = ИмяБазы;
	//	НоваяСтрока.Использовать = Истина;
	//	
	//	RegExp.Pattern=""".*""+";
	//	Массив1 = RegExp.Execute(ЭлементМассива.Value);
	//	
	//	RegExp.Pattern="""[^"";]+";
	//	Массив2 = RegExp.Execute(ЭлементМассива.Value);
	//	Если Массив2.Count()= 2 тогда
	//		// серверный вариант
	//		НоваяСтрока.SQL_Сервер		= Сред(Массив2.Item(0).Value, 2, СтрДлина(Массив2.Item(0).Value)-1);
	//		НоваяСтрока.SQL_БазаДанных	= Сред(Массив2.Item(1).Value, 2, СтрДлина(Массив2.Item(1).Value)-1);
	//	ИначеЕсли Массив1.Count() = 1 Тогда 
	//		НоваяСтрока.КаталогБазы	= Сред(Массив1.Item(0).Value, 2, СтрДлина(Массив1.Item(0).Value)-2);
	//		НоваяСтрока.ФайловаяБаза = Истина;
	//	КонецЕсли;
	//	
	// конецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанель3УстановитьТекущееЗначениеВезде(Кнопка)
	
	ТекСтрока = ЭлементыФормы.ТаблицаПараметров.ТекущаяСтрока;
	ТекКолонка = ЭлементыФормы.ТаблицаПараметров.ТекущаяКолонка;
	Если ТекСтрока <> Неопределено И ТекКолонка <> Неопределено тогда
		
		ТекЗначение = ТекСтрока[ТекКолонка.Имя];
		Если Вопрос("Все значения в текущей колонке будут заменены на """ + ТекЗначение + """" +  Символы.ПС + "Продолжить?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда 
			Возврат;
		КонецЕсли;
		
		Для каждого Строка Из ТаблицаПараметров Цикл
			Строка[ТекКолонка.Имя] = ТекЗначение;
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель2СнятьФлажки(Кнопка)
	ТаблицаПараметров.ЗаполнитьЗначения(Ложь, "Использовать");
КонецПроцедуры

Процедура КоманднаяПанель2УстановитьФлажки(Кнопка)
	ТаблицаПараметров.ЗаполнитьЗначения(Истина, "Использовать");
КонецПроцедуры

Процедура КоманднаяПанель2УстановитьТекущееЗначениеПоКолонке(Кнопка)
	КоманднаяПанель3УстановитьТекущееЗначениеВезде(Неопределено)
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ ТаблицаПараметров

Процедура ТаблицаПараметровПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	МассивДвойников  = ТаблицаПараметров.НайтиСтроки(Новый Структура("ИмяБазы",Элемент.ТекущаяСтрока.ИмяБазы));
	Если МассивДвойников.Количество()>1 тогда
		ПоказатьПредупреждение(, "Повторяющееся имя базы.");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ТаблицаПараметровПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Копирование тогда
		Элемент.Текущаястрока.ИмяБазы = "";
	КонецЕсли;
КонецПроцедуры

Процедура ТаблицаПараметровИмяБазыПриИзменении(Элемент)
	Элемент.Значение = кзгПреобразоватьВПравильноеНазвание(Элемент.Значение)
КонецПроцедуры

Процедура ТаблицаПараметровПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки <> Неопределено Тогда 
		ОформлениеСтроки.Ячейки.ФайловаяБаза.ОтображатьТекст = Истина;
		Если ДанныеСтроки.ФайловаяБаза = Истина Тогда 
			ОформлениеСтроки.Ячейки.SQL_Сервер.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			ОформлениеСтроки.Ячейки.SQL_БазаДанных.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			ОформлениеСтроки.Ячейки.ФайловаяБаза.Текст = "Файловая база";
		Иначе
			ОформлениеСтроки.Ячейки.КаталогБазы.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			ОформлениеСтроки.Ячейки.ФайловаяБаза.Текст = "SQL база";
		КонецЕсли;
		Если ДанныеСтроки.Пароль <> "" Тогда 
			ОформлениеСтроки.Ячейки.Пароль.Текст = "****************";
			ОформлениеСтроки.Ячейки.Пароль.ОтображатьТекст = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ТаблицаПараметровКаталогБазыПриИзменении(Элемент)
	ТекДанные = ЭлементыФормы.ТаблицаПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда 
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда 
			ТекДанные.Использовать = Истина;
			ТекДанные.ФайловаяБаза = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ТаблицаПараметровSQL_СерверПриИзменении(Элемент)
	ТекДанные = ЭлементыФормы.ТаблицаПараметров.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда 
		Если ЗначениеЗаполнено(Элемент.Значение) Тогда 
			ТекДанные.Использовать = Истина;
			ТекДанные.ФайловаяБаза = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

