﻿
&НаКлиенте
Процедура Добавить(Команда)
	
	лПараметрыСобытия = Новый Структура();
	лПараметрыСобытия.Вставить("идПакета"        , идПакета);
	лПараметрыСобытия.Вставить("идЗапроса"       , идЗапроса);
	лПараметрыСобытия.Вставить("идКода"          , идКода);
	лПараметрыСобытия.Вставить("ПолноеИмяФайла"  , ПолноеИмяФайла);
	лПараметрыСобытия.Вставить("КодДляВыполнения", КодДляВыполнения);
	лПараметрыСобытия.Вставить("НаименованиеКода", НаименованиеКода);

	Оповестить("ДобавитьЗапросКодИзПредпросмотра", лПараметрыСобытия);
	
	Закрыть();
	
КонецПроцедуры // Добавить()
