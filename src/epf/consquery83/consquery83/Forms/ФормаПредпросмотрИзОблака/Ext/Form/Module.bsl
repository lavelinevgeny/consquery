﻿Процедура ОсновныеДействияФормыДобавитьЗапрос(Кнопка)
	
	лПараметрыСобытия = Новый Структура();
	лПараметрыСобытия.Вставить("идПакета"      , идПакета);
	лПараметрыСобытия.Вставить("идЗапроса"     , идЗапроса);
	лПараметрыСобытия.Вставить("идКода"        , идКода);
	лПараметрыСобытия.Вставить("полноеИмяФайла", полноеИмяФайла);

	Оповестить("ДобавитьЗапросИзПредпросмотра", лПараметрыСобытия);
	
	Закрыть();
КонецПроцедуры