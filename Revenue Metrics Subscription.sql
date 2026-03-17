with monthly_revenue as (
     select
      gp.user_id,
      gp.game_name,
      date(date_trunc('month', payment_date)) as payment_month,
      sum(revenue_amount_usd) as total_revenue
      from project.games_payments as gp
      group by 1, 2, 3
),
settlement_months as (
      select
       mr.user_id,
       mr.payment_month, 
       mr.total_revenue,
       mr.game_name,
       date(payment_month - interval '1' month ) as previous_calendar_month,
       date(payment_month + interval '1' month ) as next_calendar_month,
       lag(total_revenue) over (partition by mr.user_id order by mr.payment_month) as previous_paid_month_revenue,
       lag(payment_month) over (partition by mr.user_id order by mr.payment_month) as previous_paid_month,
       lead(payment_month) over (partition by mr.user_id order by mr.payment_month ) as next_paid_month,
       gpu.language,
       case when gpu.age < 18 then 'under_18'
            when gpu.age between 18 and 24 then '18-24'
            when gpu.age between 25 and 34 then '25-34'
            when gpu.age between 35 and 44 then '35-45'
            else '45+'
            end as age_group,
       gpu.has_older_device_model
       from monthly_revenue mr
       left join project.games_paid_users gpu
       on mr.user_id = gpu.user_id
       and mr.game_name = gpu.game_name
 ),
metrics as (
      select
      payment_month,
      language,
      age_group,
      game_name,
      total_revenue,
      sum(total_revenue) as "MRR",
      count(distinct user_id) as paid_users,
      sum(case when previous_paid_month is null
                    then 1
                    end) as new_users_count,
      sum(case when previous_paid_month is null
                    then total_revenue
                    end) as new_mrr,
      sum (case when next_paid_month is null
                or next_paid_month != next_calendar_month
                    then 1
                    end ) as churned_users,
      sum (case when next_paid_month is null
                or next_paid_month != next_calendar_month
                   then total_revenue
                   end) as churned_revenue,
      sum (case when previous_paid_month = previous_calendar_month
                and total_revenue > previous_paid_month_revenue
                then total_revenue - previous_paid_month_revenue
                end) as exspansion_mrr,
      sum (case when previous_paid_month = previous_calendar_month
                and total_revenue < previous_paid_month_revenue
                then total_revenue - previous_paid_month_revenue
                end) as contraction_mrr,
      sum (case when previous_paid_month is not null
                 and previous_paid_month != previous_calendar_month
                 then total_revenue
                 end) as back_from_churn_mrr
      from settlement_months 
      group by 1, 2, 3, 4, 5
 )
 select 
       payment_month,
       game_name,
       language,
       age_group,
       total_revenue,
       "MRR",
       paid_users as users_count,
       churned_revenue,
       exspansion_mrr,
       contraction_mrr,
       back_from_churn_mrr,
       churned_users as churned_users_count,
       new_users_count,
       new_mrr
       from metrics m 
      