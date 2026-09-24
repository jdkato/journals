#import "@preview/charged-ieee:0.1.3": ieee
#show: ieee.with(
  title: [A randomized trial of zetaprol against placebo in adults with hypertension],
  authors: ((name: "A. Author", organization: [A University]),),
)

= Abstract

Hypertension is common. We tested zetaprol against placebo in a randomized trial of 120 adults. Blood pressure fell by 12 mmHg more with zetaprol than with placebo (p = 0.002). Registered as NCT01234567.

= Introduction

Earlier trials @smith2020 suggested that zetaprol lowers blood pressure. We tested that claim. The rationale is the gap in the evidence: previous trials were small. We aimed to compare the two doses for benefits and harms.

= Methods

Adults aged 18–65 years with hypertension were eligible; the exclusion criteria are in the protocol, which is at the registry with the statistical analysis plan. The sample size of 120 gave 80% power to detect a 10 mmHg difference. Randomization used a computer-generated allocation sequence, concealed in sealed envelopes until assignment. Participants and outcome assessors were blinded. The primary outcome was systolic blood pressure at 12 weeks. Adverse events were recorded at each visit. Patient and public involvement: two patient partners reviewed the consent form. A parallel-group superiority trial with 1:1 allocation, conducted at three hospitals in Norway. The intervention was 10 mg daily and the comparator was placebo, identical in appearance. Randomization used permuted blocks of four, stratified by site. There were no changes to the protocol after the trial began, and no interim analyses were planned. Groups were compared by logistic regression, missing outcomes were handled by multiple imputation, and subgroup analyses by age were prespecified.

$ Delta p = p_1 - p_0 $

= Results

Baseline characteristics were similar between groups. We analyzed 60 participants per group by intention to treat. Blood pressure fell by 12 mmHg more with zetaprol (p = 0.002; @fig-outcome). Adverse events were mild in both groups. Participants were recruited between March 2022 and May 2023, and the trial ended when the planned sample size was reached. Three participants were lost to follow-up in each group. Adherence was 92 percent, and concomitant care did not differ.

#figure(
  image("outcome.png", width: 70%),
  caption: [Blood pressure by group. Error bars are the standard deviation.],
) <fig-outcome>

= Discussion

Zetaprol lowered blood pressure at 12 weeks. One limitation is the short follow-up. The results are consistent with previous trials, and the harms were few.

= Data availability

De-identified participant data are available on request.

= Funding and competing interests

Funded by a research council, which had no role in the design. Competing interests: none.

= References

+ Smith J, et al. A paper. Nature. 2020;1:1–2.
