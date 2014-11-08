hors_d_oeuvre(artichauts_Melanie).
hors_d_oeuvre(truffes_sous_le_sel).
hors_d_oeuvre(cresson_oeuf_poche).

viande(grillade_de_boeuf).
viande(poulet_au_tilleul).

poisson(bar_aux_algues).
poisson(saumon_oseille).

dessert(sorbet_aux_poires).
dessert(fraises_chantilly).
dessert(melon_en_surprise).

calories(artichauts_Melanie, 150).
calories(truffes_sous_le_sel, 202).
calories(cresson_oeuf_poche, 212).
calories(grillade_de_boeuf, 532).
calories(poulet_au_tilleul, 400).
calories(bar_aux_algues, 292).
calories(saumon_oseille, 254).
calories(sorbet_aux_poires, 223).
calories(fraises_chantilly, 289).
calories(melon_en_surprise, 122).

/* 1) */
plat_resistance(X) :-
	viande(X).
plat_resisstance(X) :-
	poisson(X).

/* 2 */
repas(H,P,D) :-
	hors_d_oeuvre(H), plat_resistance(P), dessert(D).

/* 3 */
faible_calorie(Plat) :-
	calories(Plat, Calories), (Calories > 200), (Calories < 400).

/* 4 */
plus_calorique(Plat1, Plat2) :-
	calories(Plat1, Calories1),
	calories(Plat2, Calories2),
	(Calories1 > Calories2).

/* 5 */
valeur_calorique(H, P, D, V) :-
	repas(H,P,D),
	calories(H,X),
	calories(P,Y),
	calories(D,Z),
	V is X+Y+Z.

/* 6 */
repas_equilibre(repas(H,P,D)) :-
	valeur_calorique(H,P,D, V),
	V < 800.



	
