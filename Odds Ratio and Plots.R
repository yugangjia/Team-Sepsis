## Odds Ratio and CI
## Normally I used Python to handwrite the odds ratio and CI calculation(for practise), but in R we have same ways.

model_OR <- exp(cbind(OR = coef(model), confint(model)))
##use write_csv to output the odds ratio and rearrange the format

## Several Plots
library(ggthemr)

ggplot(data=data, mapping = aes(x=Model, y=Oddratio, fill=Sofa)) +
  geom_bar(stat="identity", width=0.9,position=position_dodge())+
  geom_errorbar(aes(ymin=under, ymax=upper), color = "#6A0545",width=.2,
                position=position_dodge(0.9))+
  geom_text(aes(label=sprintf("%.2f", Oddratio)), vjust=3.5,
            position = position_dodge(0.9), size=4, fontface="bold")+geom_hline(aes(yintercept =1.0),linetype="dashed", colour="black")+
  scale_fill_brewer(palette = "Accent") +xlab("Outcomes")+ylab("Odds Ratio Increase (per three years)")+ylim(0,2.1)+ggtitle("")+ theme(legend.title = element_blank())+
  theme_minimal() + theme(axis.title = element_text(size = 14)) + theme(legend.text=element_text(size=12)) + theme(axis.text = element_text(size = 12))+ theme(plot.title = element_text(size = 13, face = "bold"))




ggplot(data=data, mapping = aes(x=Sofa, y=Oddratio, fill=Model)) +
  geom_bar(stat="identity", width=0.9,position=position_dodge())+
  geom_errorbar(aes(ymin=under, ymax=upper), color = "#6A0545",width=.2,
                position=position_dodge(0.9))+
  geom_text(aes(label=sprintf("%.2f", Oddratio)), vjust=3.5,
            position = position_dodge(0.9), size=4, fontface="bold")+geom_hline(aes(yintercept =1.0),linetype="dashed", colour="black")+
  scale_fill_brewer(palette = "Accent", name = "Outcomes") +xlab("Sofa Score")+ylab("Odds Ratio Increase (per three years)")+ylim(0,2.1)+ggtitle("")+ theme(legend.title = element_blank())+
  theme_minimal() + theme(axis.title = element_text(size = 14)) + theme(legend.text=element_text(size=12)) + theme(axis.text = element_text(size = 12))+ theme(plot.title = element_text(size = 13, face = "bold"))

