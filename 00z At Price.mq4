//+------------------------------------------------------------------+
//|   Last edit: August 8, 2014               00z At Price.mq4       |
//|   A Chart Window Indicator.                                      |
//|   Shows Standardized Z-Score on Bid Price.                       |
//|   Outputs as Text at the Bid Line. Works on any TF.              |
//|   Note: You MUST Set the SMA Period equal to the BB system!      |
//|   Use some Chart Shift to show Indicator Output.                 |
//+------------------------------------------------------------------+
#property copyright "© 2011-2014 apipshort"
#property link "http://www.forexfactory.com/showthread.php?t=389386"
#property indicator_chart_window

extern string   Make_Sure = "    Set SMA Period equal to BB system!";
extern string  SMA_Period = "    Default Simple MA Period = 20";
extern int      smaPeriod = 20; // 20;
extern int       fontSize = 11; // 11;
extern string ScreenColor = "    Dark Screen = 1, Light = 2";
extern int        colorBG = 1;  // 1;
extern string        font = "Arial";

string obj;
string padding;  // offsetting text from Bar 0 with some left padding
color  c_1, c1_2, c2_3, c3_4, c_4; // z-score colors

//+------------------------------------------------------------------+

//modify as wanted. each color represents one Standard Deviation unit.
void SetColors(int backGround)
   {
   switch (backGround)
      {
      case 1: c_1= clrWhite; c1_2= clrHotPink; c2_3= clrLime; c3_4= clrYellow; c_4= clrRed; return;
      case 2: c_1= clrBlack; c1_2= clrBlue; c2_3= clrGreen; c3_4= clrDarkOrange; c_4= clrRed; return;

      default:     return;
      }
   } // end void SetColors(int backGround)

//+------------------------------------------------------------------+

int init()
   {
   //if found label "00z_SMA" read SMA Period from there
   int getSMA = StrToInteger(ObjectDescription("00z_SMA"));
   if(getSMA > 2) smaPeriod = getSMA;

   //if found label "00z_BG" read BG selection from there
   int getBG = StrToInteger(ObjectDescription("00z_BG"));
   if(getBG > 0) colorBG = getBG;
   if(colorBG < 1 || colorBG > 2) colorBG = 1;
   SetColors(colorBG);

   obj = StringConcatenate("00z At Price ", smaPeriod, " SMA");

   padding = "                               ";  // adjust as fit
   //........"..............................."; place holder only

   return(0);
   } // end int init()

//+------------------------------------------------------------------+

int deinit()
   {
   ObjectDelete(obj);
   return(0);
   } // end int deinit()

//+------------------------------------------------------------------+

int start()
   { // standardized z-score  = (Bid - SMA) / StdDev. see further down also

   double zScore  = (Bid - iMA(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0))
                     / iStdDev(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);

   double z = MathAbs(zScore);
   if (z<1)   color clr = c_1;
   if (z>=1 && z<2) clr = c1_2;
   if (z>=2 && z<3) clr = c2_3;
   if (z>=3 && z<4) clr = c3_4;
   if (z>=4)        clr = c_4;

   if (zScore > 0) {string sign = "+";} else {sign = "";}
   string text = StringConcatenate(padding, sign, DoubleToStr(zScore, 2), "   ", DoubleToStr(Bid, Digits - 1));

   if (!ObjectCreate(obj, OBJ_TEXT, 0,0,0,0))   ObjectCreate(obj, OBJ_TEXT, 0,0,0,0);
       if(!ObjectSet(obj, OBJPROP_TIME1, Time[0])) ObjectSet(obj, OBJPROP_TIME1, Time[0]);
       if(!ObjectSet(obj, OBJPROP_PRICE1, Bid))    ObjectSet(obj, OBJPROP_PRICE1, Bid);
   if(!ObjectSetText(obj, text, fontSize, font, clr)) ObjectSetText(obj, text, fontSize, font, clr);

   return(0);
   } // end int start()

//+--------------------------------EOP-------------------------------+/*
// more explicit code, 3 lines.
/*
double SMA =     iMA(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);
double SD  = iStdDev(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);
double zScore  = (Bid - SMA) / SD;
*/
